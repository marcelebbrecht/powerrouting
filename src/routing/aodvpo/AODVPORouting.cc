// PowerRouting for OMNeT++ - AODVPO routing
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, AODVRouting.cc

#include "AODVPORouting.h"
#include "inet/networklayer/ipv4/ICMPMessage.h"
#include "inet/networklayer/ipv4/IPv4Route.h"

#ifdef WITH_IDEALWIRELESS
#include "inet/linklayer/ideal/IdealMacFrame_m.h"
#endif // ifdef WITH_IDEALWIRELESS

#ifdef WITH_IEEE80211
#include "inet/linklayer/ieee80211/mac/Ieee80211Frame_m.h"
#endif // ifdef WITH_IEEE80211

#ifdef WITH_CSMA
#include "inet/linklayer/csma/CSMAFrame_m.h"
#endif // ifdef WITH_CSMA

#ifdef WITH_CSMACA
#include "inet/linklayer/csmaca/CsmaCaMacFrame_m.h"
#endif // ifdef WITH_CSMA

#ifdef WITH_LMAC
#include "inet/linklayer/lmac/LMacFrame_m.h"
#endif // ifdef WITH_LMAC

#ifdef WITH_BMAC
#include "inet/linklayer/bmac/BMacFrame_m.h"
#endif // ifdef WITH_BMAC

#include "inet/networklayer/common/IPSocket.h"
#include "inet/transportlayer/contract/udp/UDPControlInfo.h"
#include "inet/common/ModuleAccess.h"
#include "inet/common/lifecycle/NodeOperations.h"
#include "inet/routing/aodv/AODVRouting.h"

// typedefs for porting
typedef inet::AODVRouting AODVRouting;
typedef inet::INetfilter::IHook IHook;
typedef inet::INetworkDatagram INetworkDatagram;
typedef inet::InterfaceEntry InterfaceEntry;
typedef inet::L3Address L3Address;
typedef inet::AODVRREP AODVRREP;
typedef inet::power::IEpEnergyStorage IEpEnergyStorage;
typedef inet::power::SimpleEpEnergyStorage SimpleEpEnergyStorage;
typedef inet::IRoute IRoute;
typedef inet::AODVRouteData AODVRouteData;
typedef inet::AODVRREPACK AODVRREPACK;
typedef inet::INetfilter INetfilter;
typedef inet::INetworkDatagram INetworkDatagram;

Define_Module(AODVPORouting);

void AODVPORouting::initialize(int stage)
{
    AODVRouting::initialize(stage);

    // get energy storage and assign power based routing parameters
    energyStorage = dynamic_cast<IEpEnergyStorage *>(host->getSubmodule("energyStorage"));
    powerSensitivity = par("powerSensitivity");
    powerSensitivityMin = par("powerSensitivityMin");
    powerSensitivityMax = par("powerSensitivityMax");
    powerSensitivityDefault = par("powerSensitivityDefault");
    powerBias = par("powerBias");
    powerBiasMin = par("powerBiasMin");
    powerBiasDefault = par("powerBiasDefault");
    powerTrigger = par("powerTrigger");
    powerTriggerMin = par("powerTriggerMin");
    powerTriggerMax = par("powerTriggerMax");
    powerTriggerDefault = par("powerTriggerDefault");

    // checking and setting power routing values to default if out if bounds
    if ( powerSensitivity < powerSensitivityMin || powerSensitivity > powerSensitivityMax ) {
        EV_ERROR << "Power Routing - powerSensitivity out of bounds: " << powerSensitivity << ", setting default value: " << powerSensitivityDefault << endl;
        powerSensitivity = powerSensitivityDefault;
    }
    EV_INFO << "Power Routing - powerSensitivity: " << powerSensitivity << endl;

    if ( powerBias < powerBiasMin ) {
        EV_ERROR << "Power Routing - powerBias out of bounds: " << powerBias << ", setting default value: " << powerBiasDefault << endl;
        powerBias = powerBiasDefault;
    }
    EV_INFO << "Power Routing - powerBias: " << powerBias << endl;

    if ( powerTrigger < powerTriggerMin || powerTrigger > powerTriggerMax ) {
        EV_ERROR << "Power Routing - powerTrigger out of bounds: " << powerTrigger << ", setting default value: " << powerTriggerDefault << endl;
        powerTrigger = powerTriggerDefault;
    }
    EV_INFO << "Power Routing - powerTrigger: " << powerTrigger << endl;
}

int AODVPORouting::calculatePenalty() {
    if ( strcmp(host->getSubmodule("energyStorage")->getClassName(), "SimpleEpEnergyStorage") || strcmp(host->getSubmodule("energyStorage")->getClassName(), "inet::power::SimpleEpEnergyStorage") ) {
        EV_INFO << "Power Routing - StorageType is not SimpleEpEnergyStorage(" << host->getSubmodule("energyStorage")->getClassName() << ") returning one (normal behavior)" << endl;
        return 1;
    } else {
        EV_INFO << "Power Routing - StorageType is SimpleEpEnergyStorage, calculating hop penalty according to energy-capacity" << endl;
        relativeCharge = energyStorage->getResidualEnergyCapacity().get() / energyStorage->getNominalEnergyCapacity().get();
        hopPenaltyDouble = ((1 / (relativeCharge / powerSensitivity))) + powerBias;
        hopPenaltyDoublePreroundup = 0.999999999999999 + hopPenaltyDouble;
        hopPenalty = (int)(hopPenaltyDoublePreroundup);
        EV_INFO << "Power Routing - Capacities: " << energyStorage->getResidualEnergyCapacity() << " (actual) of " << energyStorage->getNominalEnergyCapacity() << " (nominal) " << endl;
        EV_INFO << "Power Routing - Relative charge: " << relativeCharge << " percent" << endl;
        EV_INFO << "Power Routing - Hop penalty double: " << hopPenaltyDouble << endl;
        EV_INFO << "Power Routing - Hop penalty pre round: " << hopPenaltyDoublePreroundup << endl;
        EV_INFO << "Power Routing - Hop penalty rounded: " << hopPenalty << endl;
        return hopPenalty;
    }
}

// function for calculating trigger
int AODVPORouting::calculateTrigger() {
    if ( strcmp(host->getSubmodule("energyStorage")->getClassName(), "SimpleEpEnergyStorage") || strcmp(host->getSubmodule("energyStorage")->getClassName(), "inet::power::SimpleEpEnergyStorage") ) {
        EV_INFO << "Power Routing - StorageType is not SimpleEpEnergyStorage(" << host->getSubmodule("energyStorage")->getClassName() << ") returning one (normal behavior)" << endl;
        return 1;
    } else {
        EV_INFO << "Power Routing - StorageType is SimpleEpEnergyStorage, calculating trigger according to energy-capacity" << endl;
        relativeCharge = energyStorage->getResidualEnergyCapacity().get() / energyStorage->getNominalEnergyCapacity().get();
        powerTriggerDouble = relativeCharge / powerTrigger;
        powerTriggerCalculated = (int)(powerTriggerDouble);
        EV_INFO << "Power Routing - Capacities: " << energyStorage->getResidualEnergyCapacity() << " (actual) of " << energyStorage->getNominalEnergyCapacity() << " (nominal) " << endl;
        EV_INFO << "Power Routing - Relative charge: " << relativeCharge << " percent" << endl;
        EV_INFO << "Power Routing - Power Trigger Setting: " << powerTrigger << endl;
        EV_INFO << "Power Routing - Power Trigger Calculated Double: " << powerTriggerDouble << endl;
        EV_INFO << "Power Routing - Power Trigger Calculated: " << powerTriggerCalculated << endl;
        return powerTriggerCalculated;
    }
}

void AODVPORouting::handleRREP(AODVRREP *rrep, const L3Address& sourceAddr)
{
    EV_INFO << "AODV Route Reply arrived with source addr: " << sourceAddr << " originator addr: " << rrep->getOriginatorAddr()
            << " destination addr: " << rrep->getDestAddr() << endl;

    if (rrep->getOriginatorAddr().isUnspecified()) {
        EV_INFO << "This Route Reply is a Hello Message" << endl;
        handleHelloMessage(rrep);
        delete rrep;
        return;
    }

    IRoute *previousHopRoute = routingTable->findBestMatchingRoute(sourceAddr);

    if (!previousHopRoute || previousHopRoute->getSource() != this) {
        previousHopRoute = createRoute(sourceAddr, sourceAddr, 1, false, rrep->getOriginatorSeqNum(), true, simTime() + activeRouteTimeout);
    }
    else
        updateRoutingTable(previousHopRoute, sourceAddr, 1, false, rrep->getOriginatorSeqNum(), true, simTime() + activeRouteTimeout);

    unsigned int newHopCount = rrep->getHopCount() + this->calculatePenalty();
    EV_INFO << "Power Routing - New Hop Count: " << rrep->getHopCount() + this->calculatePenalty() << endl;
    rrep->setHopCount(newHopCount);

    IRoute *destRoute = routingTable->findBestMatchingRoute(rrep->getDestAddr());
    AODVRouteData *destRouteData = nullptr;
    simtime_t lifeTime = rrep->getLifeTime();
    unsigned int destSeqNum = rrep->getDestSeqNum();

    if (destRoute && destRoute->getSource() == this) {    // already exists
        destRouteData = check_and_cast<AODVRouteData *>(destRoute->getProtocolData());
        if (!destRouteData->hasValidDestNum()) {
            updateRoutingTable(destRoute, sourceAddr, newHopCount, true, destSeqNum, true, simTime() + lifeTime);
        }
        else if (destSeqNum > destRouteData->getDestSeqNum()) {
            updateRoutingTable(destRoute, sourceAddr, newHopCount, true, destSeqNum, true, simTime() + lifeTime);
        }
        else {
            if (destSeqNum == destRouteData->getDestSeqNum() && !destRouteData->isActive()) {
                updateRoutingTable(destRoute, sourceAddr, newHopCount, true, destSeqNum, true, simTime() + lifeTime);
            }
            else if (destSeqNum == destRouteData->getDestSeqNum() && newHopCount < (unsigned int)destRoute->getMetric()) {
                updateRoutingTable(destRoute, sourceAddr, newHopCount, true, destSeqNum, true, simTime() + lifeTime);
            }
        }
    }
    else {
        destRoute = createRoute(rrep->getDestAddr(), sourceAddr, newHopCount, true, destSeqNum, true, simTime() + lifeTime);
        destRouteData = check_and_cast<AODVRouteData *>(destRoute->getProtocolData());
    }

    IRoute *originatorRoute = routingTable->findBestMatchingRoute(rrep->getOriginatorAddr());
    if (getSelfIPAddress() != rrep->getOriginatorAddr()) {
        if (originatorRoute && originatorRoute->getSource() == this) {
            AODVRouteData *originatorRouteData = check_and_cast<AODVRouteData *>(originatorRoute->getProtocolData());
            simtime_t existingLifeTime = originatorRouteData->getLifeTime();
            originatorRouteData->setLifeTime(std::max(simTime() + activeRouteTimeout, existingLifeTime));

            if (simTime() > rebootTime + deletePeriod || rebootTime == 0) {
                if (rrep->getAckRequiredFlag()) {
                    AODVRREPACK *rrepACK = createRREPACK();
                    sendRREPACK(rrepACK, sourceAddr);
                    rrep->setAckRequiredFlag(false);
                }
                destRouteData->addPrecursor(originatorRoute->getNextHopAsGeneric());

                IRoute *nextHopToDestRoute = routingTable->findBestMatchingRoute(destRoute->getNextHopAsGeneric());
                if (nextHopToDestRoute && nextHopToDestRoute->getSource() == this) {
                    AODVRouteData *nextHopToDestRouteData = check_and_cast<AODVRouteData *>(nextHopToDestRoute->getProtocolData());
                    nextHopToDestRouteData->addPrecursor(originatorRoute->getNextHopAsGeneric());
                }
                AODVRREP *outgoingRREP = rrep->dup();
                forwardRREP(outgoingRREP, originatorRoute->getNextHopAsGeneric(), 100);
            }
        }
        else
            EV_ERROR << "Reverse route doesn't exist. Dropping the RREP message" << endl;
    }
    else {
        if (hasOngoingRouteDiscovery(rrep->getDestAddr())) {
            EV_INFO << "The Route Reply has arrived for our Route Request to node " << rrep->getDestAddr() << endl;
            updateRoutingTable(destRoute, sourceAddr, newHopCount, true, destSeqNum, true, simTime() + lifeTime);
            completeRouteDiscovery(rrep->getDestAddr());
        }
    }

    delete rrep;
}

INetfilter::IHook::Result AODVPORouting::datagramForwardHook(INetworkDatagram *datagram, const InterfaceEntry *inputInterfaceEntry, const InterfaceEntry *& outputInterfaceEntry, L3Address& nextHopAddress)
{

    Enter_Method("datagramForwardHook");
    const L3Address& destAddr = datagram->getDestinationAddress();
    const L3Address& sourceAddr = datagram->getSourceAddress();

    // check if capacity changed significantly and send RERR to rebuild routes
    if ( powerTriggerLast > this->calculateTrigger() ) {
        EV_INFO << "Power Routing - Capacity changed significantly, sending RERR to rebuild routes" << endl;
        sendRERRWhenNoRouteToForward(sourceAddr);
        sendRERRWhenNoRouteToForward(destAddr);
    }
    EV_INFO << "Power Routing - Updating power trigger, old: " << powerTriggerLast << ", new: " << powerTrigger << endl;
    powerTriggerLast = this->calculateTrigger();

    return AODVRouting::datagramForwardHook(datagram, inputInterfaceEntry, outputInterfaceEntry, nextHopAddress);
}
