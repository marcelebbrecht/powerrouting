// PowerRouting for OMNeT++ - Batman router definition
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, AODVRouter.ned

package powerrouting.node.batmanpo;

import inet.node.inet.WirelessHost;
import powerrouting.routing.batmanpo.BatmanPO;
import inet.power.contract.IEnergyStorage;

module BatmanPORouter extends WirelessHost
{
    parameters:
        @display("i=device/cellphone");
        forwarding = true;
        wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");
    submodules:
        // start modification
        batmanpo: BatmanPO {
            @display("p=558,307");
        }
        // end modification
    connections:
        batmanpo.ipOut --> networkLayer.transportIn++;
        batmanpo.ipIn <-- networkLayer.transportOut++;
}
