// PowerRouting for OMNeT++ - Batman Message
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, BatmanMsg.msg


cplusplus {{
#include "inet/networklayer/common/L3Address.h"
#define DIRECTLINK 0x40
#define UNIDIRECTIONAL 0x80

#ifdef __USE_MINHOP__
#define BatPacketSize 17
#else
#define BatPacketSize 16
#endif

#define BATMAN_HNA_MSG_SIZE 5

}}

class noncobject inet::IPv4Address;
class noncobject inet::L3Address;

struct vis_data
{
    uint8_t type;
    uint8_t data;
    L3Address ip;
};

struct HnaElement
{
    L3Address addr;
    uint8_t  netmask;
};

packet BatmanPacket
{
    byteLength = BatPacketSize;
    uint8_t        version;  // batman version field
    uint8_t        flags;    // 0x80: UNIDIRECTIONAL link, 0x40: DIRECTLINK flag, ...
    uint8_t        ttl;
    uint8_t        gatewayFlags;  // flags related to gateway functions: gateway class
    unsigned short seqNumber;
    unsigned short gatewayPort;
    L3Address        orig;
    L3Address        prevSender;
    uint8_t        tq;           // Quality
    uint8_t        hops;
    HnaElement   hnaMsg[];    ///< Packet body.
}


packet visPacket {
    L3Address senderIp;
    unsigned char version;
    unsigned char gwClass;
    unsigned char tqMax;
    vis_data visData[];
}

