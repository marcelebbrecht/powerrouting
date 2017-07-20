// PowerRouting for OMNeT++ - OLSR router definition
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, AODVRouter.ned

package powerrouting.node.olsr;

import inet.node.inet.WirelessHost;
import powerrouting.routing.olsr.OLSR;
import inet.power.contract.IEnergyStorage;

module OLSRRouter extends WirelessHost
{
    parameters:
        @display("i=device/cellphone");
        forwarding = true;
        wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");
    submodules:
        // start modification
        olsr: OLSR {
            @display("p=558,307");
        }
        // end modification
    connections:
        olsr.ipOut --> networkLayer.transportIn++;
        olsr.ipIn <-- networkLayer.transportOut++;
}
