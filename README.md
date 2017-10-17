PowerRouting for OMNeT++ - Readme
=================================

With this piece of software, I contribute variants of different routing protocols
that make routing decisions based on the power source and, if on battery, remaining
capacity. This should ensure fairness with scope on power usage: The original protocols
make their decisions based on link quality and some other, link related properties. If
the devices run on battery, the nodes with the 'best' links will run out of power while
others, with quite good links, remain unused. Now, if capacity gets lower, the nodes send
requests to create new routes and ensure a lower priority. If there is a better route, 
the geometry changes, if not, not.

In the current version, the project concentrates on the routing process. It doesn't pay
any attention on inteference, modulation, physics... it's just a simple model. The real world
should stay outside. 


About the project
-----------------

I wrote this stuff for my bachelorthesis in 2017. Maybe, I'll try a master in the next
years and, maybe, I'm allowed to do further work on this stuff.  

Main GIT repository: https://github.com/marcelebbrecht/powerrouting
 

About the author
----------------

My name is Marcel Ebbrecht and I study computer science at the TU Dortmund in Germany (www.cs.tu-dortmund.de).
If you have any questions, feel free to contact me: marcel.ebbrecht@googlemail.com 


Version an status
-----------------

Current version: 1.0-rc1

For more details, please have a look at CHANGELOG.md. I'm still working on this stuff,
so there is no contribution allowed at the moment. 


License
-------

I decided to use GPLv3 for this project, see LICENSE.md. I hope, this doesn't harm any of
the used modules from the used inetmanet-3.5 framework and other used stuff. 


External code
-------------

As mentioned before, I use external code for this project, everything inside the project
is written by myself. At the moment I just use inetmanet-3.5 from aarizaq's GitHub site:

https://github.com/aarizaq/inetmanet-3.x

Big thank you to all authors, that made that stuff possible. For more information, 
please look at the packages README.md, CREDITS and License. 


OMNeT++ on Linux
------------------

I use OMNeT++ 5.1 for Windows, Build id: 170331-7c4e366 for this project:

https://omnetpp.org/component/jdownloads/send/32-release-older-versions/2309-omnetpp-5-1-linux


OMNeT++ on Windows
------------------

The preferred way ist Linux, the following could work, must not. Installing on Linux is easier,
simulations and compilation runs faster, try it. If you use Windows, use runfile "run".

I use OMNeT++ 5.1 for Windows, Build id: 170331-7c4e366 for this project:

https://omnetpp.org/component/jdownloads/send/32-release-older-versions/2308-omnetpp-5-1-windows


Time, RAM, Disk and other requirements
--------------------------------------

Results and exports need about 250G space without elog and rt files and if it deletes the vec's.
A full run, an I7 3770 with 7 active threads needs about 9-10 hours.

Also, you need a towel. A towel is somewhat usefull. Don't ask any questions, get one!


Installation Linux
------------------

Download, extract and build OMNet++. I use ~/omnetpp as target directory. 

Now, create a new workspace, download, extract, import and build inetmanet-3.x. If you use a different path than default
'inetmanet-3.x', then please correct it in run.sh.

Now, clone this project from GitHub and import it as 'powerrouting' into you workspace.

Now, apply patch for ACK message bug as mentioned under bugs (see at the end of this document) or use patch-file:

enter your workspace
cd inetmanet-3.x/src/inet/common/lifecycle
patch < ../../../../../powerrouting/patch/OperationalBase.cc.patch

Please set project reference from powerrouting to inetmanet-3.x.

Now, build inetmanet and powerrouting.

You need:
* perl
* gnuplot

If needed, set full paths in run.sh.

Also, please install the following modules:
* Statistics::Lite qw(:all)
* Statistics::PointEstimation
* Chart::Gnuplot
* Switch

Installation Windows (DEPRECATED)
---------------------------------

Download and extract OMNeT++ from above. Inetmanet uses OSG for visualization, but it's broken
in OMNeT++ 5.1 (if you build inetmanet, you get errors if vizualization feature is enabled). 

First of all, disable the following features and dependencies in inetmanet:
* AODV

Also please exclude the following path from build:
* inet/routing/extras/olsr
* inet/routing/extras/batman

Now apply patch for ACK message bug as mentioned under bugs (see at the end of this document).

Two ways to solve this issue:
* Disable vizualization features in Inetmanet project settings and comment vizualization options in common.ini, then clean and rebuild Inetmanet 
* Prior build of OMNeT++, edit configure.user:
	* Set OSG_LIBS=no
	* Set OSGEARTH_LIBS=no
	* Set WITH_OSG=no
	* Set WITH_OSGEARTH=no

Now build OMNeT++ according to manual (make clean; ./configure; make)

Ensure, that you don't have the common INET stuff in your workspace. Now download inetmanet framework
and import it, according to INSTALL inside. Default feature set is fine, now build project if not done before.

Now, clone this project from GitHub and import it as 'powerrouting' into you workspace and build it.

If you face compiler errors regarding missing links to inet, check the following on powerouting's project properties:
* C/C++ General -> Paths and Symbols -> Library Paths -> add /inet/src
* C/C++ General -> Paths and Symbols -> References -> check inet
* Project References -> check inet
* OMNeT++ -> Makemake -> src -> check Build: Makemake
* OMNeT++ -> Makemake -> src -> Makemake Options -> Target -> check shared library
* OMNeT++ -> Makemake -> src -> Makemake Options -> Compile -> check Export include paths for other projects
* OMNeT++ -> Makemake -> src -> Makemake Options -> Compile -> check Add include paths exported from referenced projects
* OMNeT++ -> Makemake -> src -> Makemake Options -> Link -> check Link with libraries exported from referenced projects
* OMNeT++ -> Makemake -> src -> Makemake Options -> Link -> check Add libraries and other linker options from enabled project features
* OMNeT++ -> Makemake -> src -> Makemake Options -> Link -> Additional libraries to link with -> add libINET

Now install GNUPlot and set the path:
* run: GNUPLOT
* subs.pl: my $gnuplotPath

Now install Perl and set the path:
* run: PERL

Also, please install the following modules:
* Statistics::Lite qw(:all)
* Statistics::PointEstimation
* Chart::Gnuplot
* Switch


Batch processing
----------------

To quickly run all simulations, go into the simulation directory and execute "./run.sh all" or "./run.sh help" for more 
infomation about the different modes. You will find proper results in simulations/results and logs in simulations/logs. 
All charts will be exported to simulations/export, also a html overview is created. All significant data will be exported
to CSV, theoretically all OMNet resultfiles can be deleted after a full run.

On windows, use 'run' instead of 'run.sh'

Inheritance
-----------

As I am working on that stuff for my bachelor thesis, I copied and ported the complete AODV and OLSR Code from inetmanet-3.5
to my project. After completion of that thesis, I will do it with inheritance - for AODV. OLSR won't work without patching
inetmanet-3.5 (OLSRPO must be friend!).


Repetitions
-----------

Currently nearly all simulations will be run multiple times, 100 atm. Line Charts and HTML reports with ANF in OMNet are only
created for runnumber 0. Due high space and resultcomputation requirenments, parameter study is limited to one run. Mixed 
modes is only for demonstrating interoperability.

Seeds
-----

I created static seeds for 100 runs inside common.ini. They're created as random numbers. You're free to change them, but
mention the Power-Drop Bug caused by routing loops on OLSR.

Simulations with AODV
---------------------

Mainly, the power-based version AODVPO does the following two tricks: Every time a packet is forwarded, the remaining
battery storage is checked. If it drops a predefined ratio, the router adds a higher value to the nextHop information
it transmitts to other routers for knows routes and send an RERR. Now the other nodes will search for a new route. Because
AODV will choose the first available route it receives with a valid RREP (aacording to https://www.ietf.org/rfc/rfc3561.txt),
the AODVPO nodes will wait a short time t before sending it and t is relative to the charge-status of the battery (see below).
To ensure functionality on low capacity (and so, high hopCounts), I raised the netDiameter for AODV and AODVPO on routers to
1024. I raised the TTL for RERR from 1 to 32, to reach more routers.

Old: nextHopCount = oldHopCount + 1
New: nextHopCount = oldHopCount + ( 1 / ( relativeCharge / powerSensitivity ) + powerBias ), where relativeCharge is in 0..1

Time t = ( 1 / ( relativeCharge / powerSensitivity ) + powerBias ) * timePenalty, where timePenalty is in 0..1

The simulations starts sending packets after 10s. 

Please create a runconfig that uses aodv.ini. The different configs are described inside the ini file. We use different scenarios:
* pure AODV and AODVPO simulations
* mixed networks to show interoperability of AODVPO with normal AODV routers
* for AODVPO we have three modes: normal opration, one mode with higher (TriggerHappy) and lower (TriggerSloppy) thresholds 
* a study simulation, that iterates about sensitivity and trigger
* a run with random recipients on AODV and AODVPO
* a run with multihop setup on AODV and AODVPO
* a run with different charge state on start on AODV and AODVPO

Feel free to experiment with the following parameters, set through aodv.ini:
* aodvpo.powerSensitivity - constant to manipulate the penalty of hopCount, higher values leads to higher penalties (min: 0.1, max: 10.0, default: 2.0)
* aodvpo.powerTrigger - steps on relative charge for sending RERR. If set to 0.20, the router sends on 80%,60%,... an RERR, low values makes it triggerhappy (min: 0.05, max: 1.0, default: 0.3)
* aodvpo.powerBias - constant value to add to hopCount for battery-based routers (min: 0.0, default: 0.0)
* aodvpo.timePenalty - constant value to add to hopCount for battery-based routers (min: 0.0, max: 1.0, default: 0.02)

The mixed mode should show, that AODV and AODVPO are compatible, only. Due several reasons, the balancing won't work. Maybe, 
I'll change that in future versions, but this will need more work on the protocol behavior of AODVPO.

Simulations with OLSR
---------------------

Mainly, the power-based version OLSRPO does the following trick: Every time a HELLO packet is received, the remaining
battery storage is checked. If it drops a predefined ratio, the router lowers its willingness. After that, the 
router would look less attractive for other hosts and so, if available, another router will be used. The different
intervals on OLSRPO for HELLO, TC, MID and REFRESH are chosen from RFC (according to https://tools.ietf.org/html/rfc3626).
To ensure lesser packet loss on OLSR, the HELLO and REFRESH Interval is set 0.5s to get sane loss rate for the price of 
high overhead. The corellation between length of these intervals and overhead is nearly linear. Changes on the TC and MID
intervals only leads to higher overhead, but got no positive effect on packet loss. You find some studies in folder 
olsr-interval-study (naming: HELLO-TC-MID-REFRESH).

New willingness = ( 7 * relativeCharge * ( 1 - powerSensitivity ) ) - powerBias, where relativeCharge and powerSensitivity is in 0..0.999999 

The simulations starts sending packets after 10s. 

Please create a runconfig that uses olsr.ini. The different configs are described inside the ini file. We use different scenarios:
* pure OLSR and OLSRPO simulations
* mixed networks to show interoperability of OLSRPO with normal OLSR routers
* for OLSRPO we have three modes: normal opration, one mode with higher (TriggerHappy) and lower (TriggerSloppy) thresholds 
* a study simulation, that iterates about sensitivity and trigger
* a run with random recipients on OLSR and OLSRPO
* a run with multihop setup on OLSR and OLSRPO
* a run with different charge state on start on OLSR and OLSRPO

Feel free to experiment with the following parameters, set through olsr.ini:
* olsrpo.powerSensitivity - constant to manipulate the penalty of willingness, higher values leads to higher penalties (min: 0.0, max: 0.999999, default: 0.0)
* olsrpo.powerTrigger - steps on relative charge for lowering willingness. If set to 0.20, the router set willingness on 80%,60%,..., low values makes it triggerhappy (min: 0.05, max: 1.0, default: 0.3)
* olsrpo.powerBias - constant value to substract for battery-based routers (min: 0.0, default: 0.0)

The mixed mode should show, that OLSR and OLSRPO are compatible, only. Due several reasons, the balancing won't work like 
in pure OLSRPO networks. Sometime balancing take effect, sometimes not. Maybe, I'll change that in future versions, 
but this will need more work on the protocol behavior of OLSRPO.


Statistics
----------

In the stats directory, you will find an analysis file for each routing protocoll. You can examine and visualize
different things, but it's only available for the first run of a simulation (it becomes unstable with huge amount
of data).

All reasonable data and charts will be processed with scavetool, perl and gnuplot. You will find proper results 
in simulations/results and logs in simulations/logs. All charts will be exported to simulations/export, also a
html overview is created. All significant data will be exported to CSV, theoretically all OMNet resultfiles can 
be deleted after a full run.

To reduce the space requirements for the CSV files, a dropout factor is added. For further details, please have
a look at the run file.


CSV Export
----------

Main statistical data is exported to export/files.


Overhead
--------

To measure routing protocol, I added a new signal in both protocols: RoutingOverhead. Everytime a protocol
specific message is sent, it's length in bytes is added. You get the overhead percentile from statistics.


Metrics
-------

Regarding to RFC2601 we got the following metrics:
* Protocol overhead
* LossRate
* End2End Delay of UDP
* RTT

Own Metrics:
* Deviation of battery capacity
* Performance (see below)


Bugs - AckTimeout
-----------------

Simulations crashing, when hosts shutdown and receive packets:
"Error: Self message 'AckTimeout' received when CsmaCaMac is down -- in module (inet::CsmaCaMac) AODVPO.router44.wlan[0].mac (id=611), at t=159.707271742315s, event #1925440"
Dont know ....

Solution: I patched a file in inetmanet-3.5 (src/inet/common/lifecycle/OperationalBase.cc), just exchange the method handleMessageWhenDown:

```
void OperationalBase::handleMessageWhenDown(cMessage *message)
{
    if (message->isSelfMessage())
        // following line is commented through errors when running out of power and mac use ack
        // now we send a message instead of throwing a runtime error, dunno if it's a dump hack ;)
        //throw cRuntimeError("Self message '%s' received when %s is down", message->getName(), getComponentType()->getName());
        EV_WARN << "Self message " << message->getName() << " received when " << getComponentType()->getName() << " is down" << endl;
    else if (simTime() == lastChange) {
        EV_WARN << getComponentType()->getName() << " is down, dropping '" << message->getName() << "' message\n";
        delete message;
    } else {
        throw cRuntimeError("Message '%s' received when %s is down", message->getName(), getComponentType()->getName());
        delete message;
    }
}
```


Bugs - Power Drops 
------------------

Sometimes, the capacity of nodes in OLSR drops in a strange manor. This ist caused by routing loops. This is caused by bad
values in HELLO, TC, MID and REFRESH intervals. Ensure, that you follow RFC-3626.


Shortterm
---------

The old manor of running long- and shortterm experiments was replaced by one simulation. Shortterm data is available for 
capacity data and extracted by scripts. Shortterm data for scalar values like packet loss isn't available yet.


Parameter Studies
-----------------

There are some parameter iteration configs (*ParameterStudy). The run-script run them multithreaded an creates charts for them. Data will be exported
to csv and, if you set it up, graphs will be exported by GnuPlot.


Performance of Protocols
------------------------

To get a simple value from studytests, I created a simple perfomance function:

Performance = ( 1 - ( packetLoss + 0.0000000000000001 ) ) / ( CapacityStdDev + 0.0000000000000001 )

The constant is added to avoid division with zero. The higher the performance, the better 
is the deviation in relation with loss rate. This will be improved in later versions.
