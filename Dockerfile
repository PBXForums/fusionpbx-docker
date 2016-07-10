FROM debian:latest
MAINTAINER Darren Williams <support@directvoip.co.uk>

# Install Required Dependencies
RUN apt-get update \
	&& apt-get upgrade -y \
	&& apt-get install -y --force-yes \
		ca-certificates \
		git \
		vim \
		haveged \
		ssl-cert \
		ghostscript \
		libtiff5-dev \
		libtiff-tools \
		nginx \
		php5 php5-cli php5-fpm php5-pgsql php5-sqlite php5-odbc php5-curl php5-imap php5-mcrypt wget curl openssh-server supervisor net-tools\
	&& git clone https://github.com/fusionpbx/fusionpbx.git /var/www/fusionpbx 

RUN chown -R www-data:www-data /var/www/fusionpbx
RUN wget https://raw.githubusercontent.com/fusionpbx/fusionpbx-install.sh/master/debian/resources/nginx/fusionpbx -O /etc/nginx/sites-available/fusionpbx && ln -s /etc/nginx/sites-available/fusionpbx /etc/nginx/sites-enabled/fusionpbx \
	&& ln -s /etc/ssl/private/ssl-cert-snakeoil.key /etc/ssl/private/nginx.key \
	&& ln -s /etc/ssl/certs/ssl-cert-snakeoil.pem /etc/ssl/certs/nginx.crt \
	&& rm /etc/nginx/sites-enabled/default
RUN curl https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add - \
	&& echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main" > /etc/apt/sources.list.d/freeswitch.list \
	&& apt-get update
RUN apt-get install -y --force-yes memcached freeswitch-meta-bare freeswitch-conf-vanilla freeswitch-sysvinit freeswitch-mod-commands freeswitch-meta-codecs \
	freeswitch-mod-console freeswitch-mod-logfile freeswitch-mod-distributor freeswitch-lang-en freeswitch-mod-say-en freeswitch-sounds-en-us-callie \
	freeswitch-music-default freeswitch-mod-enum freeswitch-mod-cdr-csv freeswitch-mod-event-socket freeswitch-mod-sofia freeswitch-mod-sofia-dbg freeswitch-mod-loopback \
	freeswitch-mod-conference freeswitch-mod-db freeswitch-mod-dptools freeswitch-mod-expr freeswitch-mod-fifo libyuv-dev freeswitch-mod-httapi \
	freeswitch-mod-hash freeswitch-mod-esl freeswitch-mod-esf freeswitch-mod-fsv freeswitch-mod-valet-parking freeswitch-mod-dialplan-xml freeswitch-dbg \
	freeswitch-mod-sndfile freeswitch-mod-native-file freeswitch-mod-local-stream freeswitch-mod-tone-stream freeswitch-mod-lua freeswitch-meta-mod-say \
	freeswitch-mod-xml-cdr freeswitch-mod-verto freeswitch-mod-callcenter freeswitch-mod-rtc freeswitch-mod-png freeswitch-mod-json-cdr freeswitch-mod-shout \
	freeswitch-mod-skypopen freeswitch-mod-skypopen-dbg freeswitch-mod-sms freeswitch-mod-sms-dbg freeswitch-mod-cidlookup freeswitch-mod-memcache \
	freeswitch-mod-imagick freeswitch-mod-tts-commandline freeswitch-mod-directory freeswitch-mod-flite
RUN usermod -a -G freeswitch www-data \
	&& usermod -a -G www-data freeswitch \
	&& chown -R freeswitch:freeswitch /var/lib/freeswitch \
	&& chmod -R ug+rw /var/lib/freeswitch \
	&& find /var/lib/freeswitch -type d -exec chmod 2770 {} \; \
	&& mkdir /usr/share/freeswitch/scripts \
	&& chown -R freeswitch:freeswitch /usr/share/freeswitch \
	&& chmod -R ug+rw /usr/share/freeswitch \
	&& find /usr/share/freeswitch -type d -exec chmod 2770 {} \; \
	&& chown -R freeswitch:freeswitch /etc/freeswitch \
	&& chmod -R ug+rw /etc/freeswitch \
	&& find /etc/freeswitch -type d -exec chmod 2770 {} \; \
	&& chown -R freeswitch:freeswitch /var/log/freeswitch \
	&& chmod -R ug+rw /var/log/freeswitch \
	&& find /var/log/freeswitch -type d -exec chmod 2770 {} \;
ENV PSQL_PASSWORD="psqlpass"  
RUN password=$(dd if=/dev/urandom bs=1 count=20 2>/dev/null | base64) \
	&& apt-get install -y --force-yes sudo postgresql 
RUN service postgresql start \
	&& sleep 10 \
	&& echo "psql -c \"CREATE DATABASE fusionpbx\";" | su - postgres \
	&& echo "psql -c \"CREATE DATABASE freeswitch\";" | su - postgres \
	&& echo "psql -c \"CREATE ROLE fusionpbx WITH SUPERUSER LOGIN PASSWORD '$PSQL_PASSWORD'\";" | su - postgres \
        && echo "psql -c \"CREATE ROLE freeswitch WITH SUPERUSER LOGIN PASSWORD '$PSQL_PASSWORD'\";" | su - postgres \
        && echo "psql -c \"GRANT ALL PRIVILEGES ON DATABASE fusionpbx to fusionpbx\";"  | su - postgres \
        && echo "psql -c \"GRANT ALL PRIVILEGES ON DATABASE freeswitch to fusionpbx\";" | su - postgres \
        && echo "psql -c \"GRANT ALL PRIVILEGES ON DATABASE freeswitch to freeswitch\";" | su - postgres 
USER root
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY start-freeswitch.sh /usr/bin/start-freeswitch.sh
VOLUME ["/var/lib/postgresql", "/etc/freeswitch", "/var/lib/freeswitch", "/usr/share/freeswitch", "/var/www/fusionpbx"]
CMD /usr/bin/supervisord -n






