// Bachelorthesis 2017 - energybased AODV routing, 2nd try
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com, TU Dortmund 2017
// routing module, derived from AODVRouting.h, version 0.2

//#ifndef __INET_AODVROUTING_H
//#define __INET_AODVROUTING_H

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

//namespace inetmanetpo {

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

///*
// * This class implements AODV routing protocol and Netfilter hooks
// * in the IP-layer required by this protocol.
// */
//
//class INET_API AODVPORouting : public cSimpleModule, public inet::ILifecycle, public inet::INetfilter::IHook, public cListener
//{
//  protected:
//    /*
//     * It implements a unique identifier for an arbitrary RREQ message
//     * in the network. See: rreqsArrivalTime.
//     */
//    class RREQIdentifier
//    {
//      public:
//        inet::L3Address originatorAddr;
//        unsigned int rreqID;
//        RREQIdentifier(const inet::L3Address& originatorAddr, unsigned int rreqID) : originatorAddr(originatorAddr), rreqID(rreqID) {};
//        bool operator==(const RREQIdentifier& other) const
//        {
//            return this->originatorAddr == other.originatorAddr && this->rreqID == other.rreqID;
//        }
//    };
//
//    class RREQIdentifierCompare
//    {
//      public:
//        bool operator()(const RREQIdentifier& lhs, const RREQIdentifier& rhs) const
//        {
//            return lhs.rreqID < rhs.rreqID;
//        }
//    };
//
//    // context
//    inet::IL3AddressType *addressType = nullptr;    // to support both IPv4 and v6 addresses.
//
//    // environment
//    cModule *host = nullptr;
//    inet::IRoutingTable *routingTable = nullptr;
//    inet::IInterfaceTable *interfaceTable = nullptr;
//    inet::INetfilter *networkProtocol = nullptr;
//
//    // AODV parameters: the following parameters are configurable, see the NED file for more info.
//    unsigned int rerrRatelimit = 0;
//    unsigned int aodvUDPPort = 0;
//    bool askGratuitousRREP = false;
//    bool useHelloMessages = false;
//    simtime_t maxJitter;
//    simtime_t activeRouteTimeout;
//    simtime_t helloInterval;
//    unsigned int netDiameter = 0;
//    unsigned int rreqRetries = 0;
//    unsigned int rreqRatelimit = 0;
//    unsigned int timeoutBuffer = 0;
//    unsigned int ttlStart = 0;
//    unsigned int ttlIncrement = 0;
//    unsigned int ttlThreshold = 0;
//    unsigned int localAddTTL = 0;
//    unsigned int allowedHelloLoss = 0;
//    simtime_t nodeTraversalTime;
//    cPar *jitterPar = nullptr;
//    cPar *periodicJitter = nullptr;
//
//    // start modification
//    // parameters for energy-optimization
//    inet::power::IEpEnergyStorage *energyStorage = nullptr;
//    double relativeCharge = 0;
//    double hopPenaltyDouble = 0;
//    double hopPenaltyDoublePreroundup = 0;
//    int hopPenalty = 0;
//    double powerSensitivity = 0;
//    double powerSensitivityMin = 0;
//    double powerSensitivityMax = 0;
//    double powerSensitivityDefault = 0;
//    double powerBias = 0;
//    double powerBiasMin = 0;
//    double powerBiasDefault = 0;
//    double powerTrigger = 0;
//    double powerTriggerMin = 0;
//    double powerTriggerMax = 0;
//    double powerTriggerDefault = 0;
//    double powerTriggerDouble = 0;
//    int powerTriggerCalculated = 0;
//    int powerTriggerLast = 0;
//    // end modification
//
//    // the following parameters are calculated from the parameters defined above
//    // see the NED file for more info
//    simtime_t deletePeriod;
//    simtime_t myRouteTimeout;
//    simtime_t blacklistTimeout;
//    simtime_t netTraversalTime;
//    simtime_t nextHopWait;
//    simtime_t pathDiscoveryTime;
//
//    // state
//    unsigned int rreqId = 0;    // when sending a new RREQ packet, rreqID incremented by one from the last id used by this node
//    unsigned int sequenceNum = 0;    // it helps to prevent loops in the routes (RFC 3561 6.1 p11.)
//    std::map<inet::L3Address,inet::WaitForRREP *> waitForRREPTimers;    // timeout for Route Replies
//    std::map<RREQIdentifier, simtime_t, RREQIdentifierCompare> rreqsArrivalTime;    // maps RREQ id to its arriving time
//    inet::L3Address failedNextHop;    // next hop to the destination who failed to send us RREP-ACK
//    std::map<inet::L3Address, simtime_t> blacklist;    // we don't accept RREQs from blacklisted nodes
//    unsigned int rerrCount = 0;    // num of originated RERR in the last second
//    unsigned int rreqCount = 0;    // num of originated RREQ in the last second
//    simtime_t lastBroadcastTime;    // the last time when any control packet was broadcasted
//    std::map<inet::L3Address, unsigned int> addressToRreqRetries;    // number of re-discovery attempts per address
//
//    // self messages
//    cMessage *helloMsgTimer = nullptr;    // timer to send hello messages (only if the feature is enabled)
//    cMessage *expungeTimer = nullptr;    // timer to clean the routing table out
//    cMessage *counterTimer = nullptr;    // timer to set rrerCount = rreqCount = 0 in each second
//    cMessage *rrepAckTimer = nullptr;    // timer to wait for RREP-ACKs (RREP-ACK timeout)
//    cMessage *blacklistTimer = nullptr;    // timer to clean the blacklist out
//
//    // lifecycle
//    simtime_t rebootTime;    // the last time when the node rebooted
//    bool isOperational = false;
//
//    // internal
//    std::multimap<inet::L3Address, inet::INetworkDatagram *> targetAddressToDelayedPackets;    // queue for the datagrams we have no route for
//
//  protected:
//    void handleMessage(cMessage *msg) override;
//    void initialize(int stage) override;
//    virtual int numInitStages() const override { return inet::NUM_INIT_STAGES; }
//
//    /* Route Discovery */
//    void startRouteDiscovery(const inet::L3Address& target, unsigned int timeToLive = 0);
//    void completeRouteDiscovery(const inet::L3Address& target);
//    bool hasOngoingRouteDiscovery(const inet::L3Address& destAddr);
//    void cancelRouteDiscovery(const inet::L3Address& destAddr);
//
//    /* Routing Table management */
//    void updateRoutingTable(inet::IRoute *route, const inet::L3Address& nextHop, unsigned int hopCount, bool hasValidDestNum, unsigned int destSeqNum, bool isActive, simtime_t lifeTime);
//    inet::IRoute *createRoute(const inet::L3Address& destAddr, const inet::L3Address& nextHop, unsigned int hopCount, bool hasValidDestNum, unsigned int destSeqNum, bool isActive, simtime_t lifeTime);
//    bool updateValidRouteLifeTime(const inet::L3Address& destAddr, simtime_t lifetime);
//    void scheduleExpungeRoutes();
//    void expungeRoutes();
//
//    /* Control packet creators */
//    inet::AODVRREPACK *createRREPACK();
//    inet::AODVRREP *createHelloMessage();
//    inet::AODVRREQ *createRREQ(const inet::L3Address& destAddr);
//    inet::AODVRREP *createRREP(inet::AODVRREQ *rreq, inet::IRoute *destRoute, inet::IRoute *originatorRoute, const inet::L3Address& sourceAddr);
//    inet::AODVRREP *createGratuitousRREP(inet::AODVRREQ *rreq, inet::IRoute *originatorRoute);
//    inet::AODVRERR *createRERR(const std::vector<inet::UnreachableNode>& unreachableNodes);
//
//    /* Control Packet handlers */
//    void handleRREP(inet::AODVRREP *rrep, const inet::L3Address& sourceAddr);
//    void handleRREQ(inet::AODVRREQ *rreq, const inet::L3Address& sourceAddr, unsigned int timeToLive);
//    void handleRERR(inet::AODVRERR *rerr, const inet::L3Address& sourceAddr);
//    void handleHelloMessage(inet::AODVRREP *helloMessage);
//    void handleRREPACK(inet::AODVRREPACK *rrepACK, const inet::L3Address& neighborAddr);
//
//    /* Control Packet sender methods */
//    void sendRREQ(inet::AODVRREQ *rreq, const inet::L3Address& destAddr, unsigned int timeToLive);
//    void sendRREPACK(inet::AODVRREPACK *rrepACK, const inet::L3Address& destAddr);
//    void sendRREP(inet::AODVRREP *rrep, const inet::L3Address& destAddr, unsigned int timeToLive);
//    void sendGRREP(inet::AODVRREP *grrep, const inet::L3Address& destAddr, unsigned int timeToLive);
//
//    /* Control Packet forwarders */
//    void forwardRREP(inet::AODVRREP *rrep, const inet::L3Address& destAddr, unsigned int timeToLive);
//    void forwardRREQ(inet::AODVRREQ *rreq, unsigned int timeToLive);
//
//    /* Self message handlers */
//    void handleRREPACKTimer();
//    void handleBlackListTimer();
//    void sendHelloMessagesIfNeeded();
//    void handleWaitForRREP(inet::WaitForRREP *rrepTimer);
//
//    /* General functions to handle route errors */
//    void sendRERRWhenNoRouteToForward(const inet::L3Address& unreachableAddr);
//    void handleLinkBreakSendRERR(const inet::L3Address& unreachableAddr);
//    virtual void receiveSignal(cComponent *source, simsignal_t signalID, cObject *obj, cObject *details) override;
//
//    /* Netfilter hooks */
//    Result ensureRouteForDatagram(inet::INetworkDatagram *datagram);
//    virtual Result datagramPreRoutingHook(inet::INetworkDatagram *datagram, const inet::InterfaceEntry *inputInterfaceEntry, const inet::InterfaceEntry *& outputInterfaceEntry, inet::L3Address& nextHopAddress) override { Enter_Method("datagramPreRoutingHook"); return ensureRouteForDatagram(datagram); }
//    virtual Result datagramForwardHook(inet::INetworkDatagram *datagram, const inet::InterfaceEntry *inputInterfaceEntry, const inet::InterfaceEntry *& outputInterfaceEntry, inet::L3Address& nextHopAddress) override;
//    virtual Result datagramPostRoutingHook(inet::INetworkDatagram *datagram, const inet::InterfaceEntry *inputInterfaceEntry, const inet::InterfaceEntry *& outputInterfaceEntry, inet::L3Address& nextHopAddress) override { return ACCEPT; }
//    virtual Result datagramLocalInHook(inet::INetworkDatagram *datagram, const inet::InterfaceEntry *inputInterfaceEntry) override { return ACCEPT; }
//    virtual Result datagramLocalOutHook(inet::INetworkDatagram *datagram, const inet::InterfaceEntry *& outputInterfaceEntry, inet::L3Address& nextHopAddress) override { Enter_Method("datagramLocalOutHook"); return ensureRouteForDatagram(datagram); }
//    void delayDatagram(inet::INetworkDatagram *datagram);
//
//    /* Helper functions */
//    inet::L3Address getSelfIPAddress() const;
//    void sendAODVPacket(inet::AODVControlPacket *packet, const inet::L3Address& destAddr, unsigned int timeToLive, double delay);
//    void clearState();
//
//    /* Lifecycle */
//    virtual bool handleOperationStage(inet::LifecycleOperation *operation, int stage, inet::IDoneCallback *doneCallback) override;
//
//    // start modification
//    // calculate the penalty and trigger
//    int calculatePenalty();
//    int calculateTrigger();
//    // end modification
//
//  public:
//    AODVPORouting();
//    virtual ~AODVPORouting();
//};

//} // namespace inet

//#endif    // ifndef AODVROUTING_H_

