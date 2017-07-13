// PowerRouting for OMNeT++ - AODVPO router definition
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, AODVRouter.ned

package powerrouting.node.aodvpo;

import inet.node.inet.WirelessHost;
import powerrouting.routing.aodvpo.AODVPORouting;
import inet.power.contract.IEnergyStorage;

module AODVPORouter extends WirelessHost
{
    parameters:
        @display("i=device/cellphone");
        forwarding = true;
        wlan[*].mgmtType = default("Ieee80211MgmtAdhoc");
    submodules:
        aodvpo: AODVPORouting {
            @display("p=558,307");
        }
    connections:
        aodvpo.ipOut --> networkLayer.transportIn++;
        aodvpo.ipIn <-- networkLayer.transportOut++;
}
