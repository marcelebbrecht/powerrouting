// PowerRouting for OMNeT++ - AODV control packets
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, AODVControlPackets.msg

cplusplus {{
#include "inet/networklayer/common/L3Address.h"
typedef inet::L3Address L3Address;
}}

class noncobject L3Address;

//
// Helper struct to represent (L3Address, sequence number) pairs in a RERR message
//
struct UnreachableNode
{
    L3Address addr;
    unsigned int seqNum;
};

enum AODVControlPacketType
{
    RREQ = 1;
    RREP = 2;
    RERR = 3;
    RREPACK = 4;
};

//
// Base packet for AODV Control Packets
//
packet AODVControlPacket
{
    unsigned int packetType;
}

//
// Represents an AODV Route Request
//
class AODVRREQ extends AODVControlPacket
{
    packetType = RREQ;
    bool joinFlag;
    bool repairFlag;
    bool gratuitousRREPFlag;
    bool destOnlyFlag;
    bool unknownSeqNumFlag;
    unsigned int hopCount;
    unsigned int rreqId;
    L3Address destAddr;
    unsigned int destSeqNum;
    L3Address originatorAddr;
    unsigned int originatorSeqNum;
}

//
// Represents an AODV Route Reply
//
class AODVRREP extends AODVControlPacket
{
    packetType = RREP;
    bool repairFlag;
    bool ackRequiredFlag;
    unsigned int prefixSize;
    unsigned int hopCount;
    L3Address destAddr;
    unsigned int destSeqNum;
    L3Address originatorAddr;
    unsigned int originatorSeqNum;
    simtime_t lifeTime;
}

//
// Represents an AODV Route Error
//
class AODVRERR extends AODVControlPacket
{
    packetType = RERR;
    UnreachableNode unreachableNodes[];
    bool noDeleteFlag;
    unsigned int destCount;
}

//
// Represents an AODV Route Reply ACK
//
class AODVRREPACK extends AODVControlPacket
{
    packetType = RREPACK;
}

//
// Represents a timer for a Route Reply packet
//
message WaitForRREP
{
    L3Address destAddr;
    unsigned int lastTTL;
    bool fromInvalidEntry;
}
