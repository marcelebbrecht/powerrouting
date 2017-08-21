PowerRouting for OMNeT++ - Changelog
====================================


Version: 0.1
------------

Completed: 2017-06-23

* Very, very first version
* Successfully modified AODV


Version: 0.2
------------

Completed: 2017-06-27

* Ported to inetmanet-3.5
* Successfully modified OLSR routing


Version: 0.3
------------

Completed: 2017-07-13

* Complete, clean rewrite with class extension and own project: AODVPO
* Switched from SVN to Git
* Moved whole project to GitHub
* Readme, Todo, Changelog rewritten to MD
* License GPLv3 added 
* One Statistic file created
* Icon for routers with IdealStorage changed to accesspoint
* NED files cleaned and renamed
* INI file splitted
* Comments
* Better parameters for Sloppy,Normal,Happy -> Readme, defaults
* Longterm run and stats packets transmitted


Version: 0.4
------------

Completed: 2017-07-20

* Readme massive update
* Typedef for AODVPO
* Port OLSR
* Comments and clean OLSR
* Runtime for normal tests 3600
* Adjust power consumption for all protocols
* Separated modes on run for protocols
* Verbose mode for run
* Port AODV
* Create OLSR Router and test
* Runfile multithreaded runs on CMD
* Disabled elog via common.ini
* Runfile improved, more modes, better code
* Created chart sheets
* Divide ini's
* Switched from pingApp to udpApp, adapt stats
* Lower time, raise power consumption for shorter simulations
* Remove multiple senders, only one sender and one receiver in project
* Comments and headers completed
* Tested OLSR router
* Higher Bitrate and other power consumption rated
* Created OLSRPO router and routingA
* Fixed Bug with power trigger


Version: 0.5
------------

Completed: 2017-07-22

* Ported batman to project
* added batmanpo, but with same functionality as batman
* minor bugfixes on runscript
* fixed readme installation instruction


Version: 0.6
------------

Completed: 2017-07-23

* More runs with different parameter values and statistics


Version: 0.7
------------

Completed: 2017-07-24

* CSV and PNG export for study cases added


Version: 0.8
------------

Completed: 2017-07-26

* Performance charts added to study cases
* Tests with dymo (look at attic)


Version: 0.9
------------

Completed: 2017-07-28

* Multiple runs: run, stats, plots, readme, seed
* Comparision: stats, readme


Version: 0.91
-------------

Completed: 2017-07-29

* Bugfixes on stats creation


Version: 0.92
-------------

Completed: 2017-07-30

* Filtering on results
* More Test cases
* Fixes on Chart


Version: 0.93
-------------

Completed: In Progress

* Much, much more repetitions
* Added min/max/avg visualization to ANF files
* Batman and DYMO excluded from further work, focus is on olsr and aodv
