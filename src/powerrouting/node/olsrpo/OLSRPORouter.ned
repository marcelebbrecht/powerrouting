// PowerRouting for OMNeT++ - OLSRPO router definition
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, AODVRouter.ned

package powerrouting.node.olsrpo;

import inet.node.inet.WirelessHost;
import powerrouting.routing.olsrpo.OLSRPO;
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
