// PowerRouting for OMNeT++ - AODV router definition
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, AODVRouter.ned

package powerrouting.node.aodv;

import inet.node.inet.WirelessHost;
import powerrouting.routing.aodv.AODVRouting;


//
// It models a ~WirelessHost extended with ~AODVRouting submodule.
//
// AODV is an on-demand MANET routing protocol. Each node
// works similar to a 'router': they manage their own routing
// tables, send request for routes and consult the IP layer via
// Netfilter hooks for data forwarding.
//
// Scenerios where AODV routing is desired use this module as a
// host module.
//
// For more info about AODVRouting, see the corresponding module:
// ~AODVRouting and its C++ implementation with the same name.
//
// The AODV v.2 (known as DYMO) is also implemented: ~DYMO,
// ~DYMORouter.
//
module AODVRouter extends WirelessHost
{
    parameters:
        @display("i=device/cellphone");
        forwarding = true;
        wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");
    submodules:
        aodv: AODVRouting {
            @display("p=558,307");
        }
    connections:
        aodv.ipOut --> networkLayer.transportIn++;
        aodv.ipIn <-- networkLayer.transportOut++;
}
