// PowerRouting for OMNeT++ - AODVPO routing
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, AODVRouting.h

#include "inet/common/INETDefs.h"
#include "inet/networklayer/contract/IInterfaceTable.h"
#include "inet/networklayer/contract/IL3AddressType.h"
#include "inet/networklayer/contract/IRoutingTable.h"
#include "inet/networklayer/contract/INetfilter.h"
#include "inet/common/lifecycle/ILifecycle.h"
#include "inet/common/lifecycle/NodeStatus.h"
#include "inet/transportlayer/contract/udp/UDPSocket.h"
#include "inet/routing/aodv/AODVRouteData.h"
#include "inet/transportlayer/udp/UDPPacket.h"
#include "inet/routing/aodv/AODVControlPackets_m.h"
#include "inet/power/contract/IEnergyStorage.h"
#include "inet/power/storage/SimpleEpEnergyStorage.h"
#include "inet/routing/aodv/AODVRouting.h"
#include <map>

class AODVPORouting : public inet::AODVRouting
{
  protected:
    // parameters for energy-optimization
    inet::power::IEpEnergyStorage *energyStorage = nullptr;
    double relativeCharge = 0;
    double hopPenaltyDouble = 0;
    double hopPenaltyDoublePreroundup = 0;
    int hopPenalty = 0;
    double powerSensitivity = 0;
    double powerSensitivityMin = 0;
    double powerSensitivityMax = 0;
    double powerSensitivityDefault = 0;
    double powerBias = 0;
    double powerBiasMin = 0;
    double powerBiasDefault = 0;
    double powerTrigger = 0;
    double powerTriggerMin = 0;
    double powerTriggerMax = 0;
    double powerTriggerDefault = 0;
    double powerTriggerDouble = 0;
    int powerTriggerCalculated = 0;
    int powerTriggerLast = 0;

  protected:
    // override initialization, RREP creation and forwarding
    void initialize(int stage) override;
    void handleRREP(inet::AODVRREP *rrep, const inet::L3Address& sourceAddr);
    inet::INetfilter::IHook::Result datagramForwardHook(inet::INetworkDatagram *datagram, const inet::InterfaceEntry *inputInterfaceEntry, const inet::InterfaceEntry *& outputInterfaceEntry, inet::L3Address& nextHopAddress) override;

    // calculate the penalty and trigger
    int calculatePenalty();
    int calculateTrigger();
};
