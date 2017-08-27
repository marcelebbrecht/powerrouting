PowerRouting for OMNeT++ - Readme
=================================

With this piece of software, I contribute variants of different routing protocols
that make routing decisions based on the power source and, if ob battery, remaining
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

Current version: 0.93

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


OMNeT++ on Windows
------------------

I use Windows Version of OMNeT++ 5.1, Build id: 170331-7c4e366 for this project:

https://omnetpp.org/component/jdownloads/send/32-release-older-versions/2308-omnetpp-5-1-windows

Linux wasn't tested, yet.


Space requirements
------------------

Until 0.92: Results and exports need about 15-20G space. A full run, an I7 3770 with 7 active threads 
needs about 2 hours.

Dunno atm ;) To much repitions and modes to run all at once. I will do a full run this night and hope
the 1TB disk mounted on results directory will fit. 

Installation
------------

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
  Now Build OMNeT++ according to manual (make clean; ./configure; make)

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

If you want to export the runscript nice gnuplot graphs, please install GnuPlot and set the path in 'run'-file.

Batch processing
----------------

To quickly run all simulations, go into the simulation directory and execute "./run all" or "./run help" for more 
infomation about the different modes. You will find proper results in results and logs in simulations/logs. 


Inheritance
-----------

As I am working on that stuff for my bachelor thesis, I copied and ported the complete AODV and OLSR Code from inetmanet-3.5
to my project. After completion of that thesis, I will do it with inheritance - for AODV. OLSR won't work without patching
inetmanet-3.5 (OLSRPO must be friend!).


Repetitions
-----------

Currently nearly all simulations will be run multiple times. Line Charts and HTML reports will be only created for runnumber 0.
Due high space and resultcomputation requirenments, parameter study is limited to one run. Mixed modes is only for demonstrating
interoperability


Simulations with AODV
---------------------

Mainly, the power-based version AODVPO does the following trick: Every time a packet is forwarded, the remaining
battery storage is checked. If it drops a predefined ratio, the router adds a higher value to the nextHop information
it transmitts to other routers for knows routes and send an RERR. After that, the router would look less attractive for 
other hosts and so, if available, another router will be used. To ensure functionality on low capacity (and so, high
hopCounts), I raised the netDiameter for AODV and AODVPO on routers to 1024. I raised the TTL for RERR from 1 to 3, to 
reach more routers.

Old: nextHopCount = oldHopCount + 1
New: nextHopCount = oldHopCount + ( 1 / ( relativeCharge / powerSensitivity ) + powerBias ), where relativeCharge is in 0..1

The simulations starts sending packets after 10s. 

Please create a runconfig that uses aodv.ini. The different configs are described inside the ini file. We use different scenarios:
* pure AODV and AODVPO simulations
* mixed networks to show interoperability of AODVPO with normal AODV routers
* for AODVPO we have three modes: normal opration, one mode with higher (TriggerHappy) and lower (TriggerSloppy) thresholds 
* longterm run (all routing nodes will run out of battery before end) to examine which mode transmitts more packets

Feel free to experiment with the following parameters, set through aodv.ini:
* aodvpo.powerSensitivity - constant to manipulate the penalty of hopCount, higher values leads to higher penalties (min: 0.1, max: 10.0, default: 2.0)
* aodvpo.powerTrigger - steps on relative charge for sending RERR. If set to 0.20, the router sends on 80%,60%,... an RERR, low values makes it triggerhappy (min: 0.05, max: 1.0, default: 0.3)
* aodvpo.powerBias - constant value to add to hopCount for battery-based routers (min: 0.0, default: 0.0)


Simulations with OLSR
---------------------

Mainly, the power-based version OLSRPO does the following trick: Every time a HELLO packet is received, the remaining
battery storage is checked. If it drops a predefined ratio, the router lowers its willingness. After that, the 
router would look less attractive for other hosts and so, if available, another router will be used.

New willingness = ( 7 * relativeCharge * ( 1 - powerSensitivity ) ) - powerBias, where relativeCharge and powerSensitivity is in 0..0.999999 

The simulations starts sending packets after 10s. 

Please create a runconfig that uses olsr.ini. The different configs are described inside the ini file. We use different scenarios:
* pure OLSR and OLSRPO simulations
* mixed networks to show interoperability of OLSRPO with normal OLSR routers
* for OLSRPO we have three modes: normal opration, one mode with higher (TriggerHappy) and lower (TriggerSloppy) thresholds 
* longterm run (all routing nodes will run out of battery before end) to examine which mode transmitts more packets

Feel free to experiment with the following parameters, set through olsr.ini:
* olsrpo.powerSensitivity - constant to manipulate the penalty of willingness, higher values leads to higher penalties (min: 0.0, max: 0.999999, default: 0.0)
* olsrpo.powerTrigger - steps on relative charge for lowering willingness. If set to 0.20, the router set willingness on 80%,60%,..., low values makes it triggerhappy (min: 0.05, max: 1.0, default: 0.3)
* olsrpo.powerBias - constant value to substract for battery-based routers (min: 0.0, default: 0.0)


Simulations with Batman
-----------------------

BatmanPO is included, but still with same functionality as Batman. It seems, that this protocol do a quite good balancing so 
power optimization seems useless. I will do further investigation in next versions.

The simulations starts sending packets after 10s. 

Please create a runconfig that uses batman.ini. The different configs are described inside the ini file, but they're, as
mentioned before, nearly useless:
* pure Batman and BatmanPO simulations
* mixed networks to show interoperability of BatmanPO with normal Batman routers
* for BatmanPO we have three modes: normal opration, one mode with higher (TriggerHappy) and lower (TriggerSloppy) thresholds 
* longterm run (all routing nodes will run out of battery before end) to examine which mode transmitts more packets

Since version 0.93 BATMAN is not longer maintained. Maybe I return to that piece of work later on.


Simulations with DYMO
---------------------

I tried to port DYMO, but it seems, that it doesn't work with CSMA/CA, so there is no sensefull comparision 
possible. I moved all to the attic, maybe I give this a second shot later.


Statistics
----------

Mixed configurations are not included in stats or longterm, they're only for demonstation of interoperability.

In the stats directory, you will find an analysis file for each routing protocoll. Here you can examine and visualize different things:
* for each simulation you can examine power consumption of every router on battery as timeline (lower deviation is better)
* for each simulation you can compare the battery status at the end of the simulation (lower deviation is better)
* the sum of available power at the end of all simulations except mixed and longterm
* the standard deviation of available power at the end of all simulations except mixed and longterm (lower is better)
* the udp loss rate for all simulations (lower is better)
* the count of transmitted packets for all simulations (higher is better)

There are also some chart sheets for the main charts.


Bugs
----

Simulations crashing, when hosts shutdown and receive packets:
"Error: Self message 'AckTimeout' received when CsmaCaMac is down -- in module (inet::CsmaCaMac) AODVPO.router44.wlan[0].mac (id=611), at t=159.707271742315s, event #1925440"
Dont know ....

Solution: I patched a file in inetmanet-3.5 (src/inet/common/lifecycle/OperationalBase.cc), just exchange the method handleMessageWhenDown:

void OperationalBase::handleMessageWhenDown(cMessage *message)
{
    if (message->isSelfMessage())
        // following line is commented through errors when running out of power and mac use ack
        // now we send a message instead of throwing a runtime error, dunno if it's a dump hack ;)
        //throw cRuntimeError("Self message '%s' received when %s is down", message->getName(), getComponentType()->getName());
        EV_WARN << "Self message " << message->getName() << " received when " << getComponentType()->getName() << " is down" << endl;
    else if (simTime() == lastChange)
        EV_WARN << getComponentType()->getName() << " is down, dropping '" << message->getName() << "' message\n";
    else
        throw cRuntimeError("Message '%s' received when %s is down", message->getName(), getComponentType()->getName());
    delete message;
}


Longterm
--------

There are some longer simulation configs. Unless hosts doesn't suddenly dis- and reapper or we make something more intelligent, longterm tests are nearly useless.


Parameter Studies
-----------------

There are some parameter iteration configs (*ParameterStudy). The run-script run them multithreaded an creates charts for them. Data will be exported
to csv and, if you set it up, graphs will be exported by GnuPlot. A HTML report with all plots from runnumber 0 will be created.


Performance of Protocols
------------------------

To get a simple value from studytests, I created a simple perfomance function:

Performance = ( 1 - ( packetLoss + 0.0000000000000001 ) ) / ( CapacityStdDev + 0.0000000000000001 )

The constant is added to avoid division with zero. The higher the performance, the better 
is the deviation in relation with loss rate.


Protocol comparision
--------------------

To show the effect of specific festures of these protocols, reactiv AODV againt proactive OLSR, I created specific comparision
simulations and charts. There are two modes: One host sends to another host, one host sends to all hosts. You will see, that 
OLSR got a lesser LossRate on second scenario. 


Result filtering
----------------

To lower space usage, results will be filtered after each run. We only keep capacity and received/sent upd packets.