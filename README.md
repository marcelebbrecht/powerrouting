PowerRouting for OMNeT++
========================

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
 
About the author
----------------

My name is Marcel Ebbrecht and I study computer science at the TU Dortmund in Germany (www.cs.tu-dortmund.de).
If you have any questions, feel free to contact me: marcel.ebbrecht@googlemail.com 

Version an status
-----------------

Current version: 0.3

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

OMNeT++
-------

I use OMNeT++ 5.1, Build id: 170331-7c4e366 for this project.


Getting started
---------------

Download and install OMNeT++ from above. Ensure, that you don't have the common INET
stuff in your workspace. Now download inetmanet framework and import it, according to
INSTALL inside.


