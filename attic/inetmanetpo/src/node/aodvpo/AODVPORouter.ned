// Bachelorthesis 2017 - energybased AODV routing, 2nd try
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com, TU Dortmund 2017
// NED router module, derived from AODVRouter.ned, version 0.2

package inetmanetpo.node.aodvpo;

import inet.node.inet.WirelessHost;
import inetmanetpo.routing.aodvpo.AODVPORouting;
import inet.power.contract.IEnergyStorage;

module AODVPORouter extends WirelessHost
{
    parameters:
        @display("i=device/cellphone");
        forwarding = true;
        wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");
    submodules:
        // start modification
        aodvpo: AODVPORouting {
            @display("p=558,307");
        }
        // end modification
    connections:
        aodvpo.ipOut --> networkLayer.transportIn++;
        aodvpo.ipIn <-- networkLayer.transportOut++;
}
