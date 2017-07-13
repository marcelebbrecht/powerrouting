// Bachelorthesis 2017 - energybased OLSR routing, 2nd try
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com, TU Dortmund 2017
// NED router module, derived from OLSRRouter.ned, version 0.2

package inetmanetpo.node.olsrpo;

import inet.node.inet.WirelessHost;
import inetmanetpo.routing.olsrpo.OLSRPO;
import inet.power.contract.IEnergyStorage;

module OLSRPORouter extends WirelessHost
{
    parameters:
        @display("i=device/cellphone");
        forwarding = true;
        wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");
    submodules:
        // start modification
        olsrpo: OLSRPO {
            @display("p=558,307");
        }
        // end modification
    connections:
        olsrpo.ipOut --> networkLayer.transportIn++;
        olsrpo.ipIn <-- networkLayer.transportOut++;
}
