![alt text][logo]
[logo]: https://raw.githubusercontent.com/fusionpbx/fusionpbx-docs/master/source/_static/images/logo.png "FusionPBX Logo"

Welcome to FusionPBX Docker
=========================

Usage
-----

First pull the image using the command:
```
docker pull digitaldaz/fusionpbx-docker
```
Once the image has downloaded:
```
docker run --net=host --privileged --name container-name-here -d digitaldaz/fusionpbx-docker
```
The placeholder container-name-here can be set to anything you like. This will start the container running, we now need to set the 
database password, to do this we need to find the container id and so we run:
```
docker ps
```
This will produce output similar to:
```
CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS
017c1a7397e1        digitaldaz/fusionpbx-docker   "/bin/sh -c '/usr/bin"   10 seconds ago      Up 7 seconds
```
Replacing the Container ID with our own, and substituting mypassword with an appropriate one we do:
```
docker exec 017c1a7397e1 sudo -u postgres psql -c "ALTER USER fusionpbx WITH PASSWORD 'mypassword';"
```
You will know this has been successful when it returns:
```
ALTER ROLE
```
We now need to visit the web interface to set up FusionPBX. In your browser put:
```
http://your-ip-here
```


About FusionPBX
---------------

**FusionPBX** is an open source project that provides a customizable and
flexible web interface to the very powerful and highly scalable
multi-platform voice switch called [FreeSWITCH](http://www.freeswitch.org/).

FusionPBX provides a GUI for for unlimited
extensions, voicemail-to-email, music on hold, call parking, analog
lines or high density T1/E1 circuits, and many other Features. FusionPBX
provides the functionality that business need and provides corporate
level phone system features to small, medium and large businesses.

Benefits of FusionPBX
---------------------

1. Adding extra functionality to the incredibly robust FreeSWITCH VoIP Platform.
2. Makes FreeSWITCH easy to administer while at the same time
   still allowing you to work directly within FreeSWITCH Command Line Interface (fs_cli) when you need to. 
3. Gives your users and tenants an attractive GUI interface to interact with. 


FusionPBX provides:

* Call Block
* Call Broadcast
* Call Flows
* Call Center
* Call Detail Records
* Conference Center
* Contacts
* Fax Server
* Follow-Me
* Hot Desking
* IVR Menus
* Multi-Tenant
* Music on Hold
* Queues
* Recording
* Time Groups
* Voicemail
* and lots more...

Our Eco-System
--------------

We are a **global community** that has an open and **very friendly** eco-system.  We encourage community engagement, contribution and feedback. Please join us by getting involved with giving feedback, new feature ideas, helping out with code or Documentation.


Most of the core folks who develop and use FusionPBX can be found hanging out in Freenode IRC in the **#fusionpbx** channel. Come join us and meet the team.
