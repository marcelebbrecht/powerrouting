// PowerRouting for OMNeT++ - Batman router definition
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, AODVRouter.ned

package powerrouting.node.batman;

import inet.node.inet.WirelessHost;
import powerrouting.routing.batman.Batman;
import inet.power.contract.IEnergyStorage;

module BatmanRouter extends WirelessHost
{
    parameters:
        @display("i=device/cellphone");
        forwarding = true;
        wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");
    submodules:
        // start modification
        batman: Batman {
            @display("p=558,307");
        }
        // end modification
    connections:
        batman.ipOut --> networkLayer.transportIn++;
        batman.ipIn <-- networkLayer.transportOut++;
}
