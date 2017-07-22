// PowerRouting for OMNeT++ - Batman Message
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, BatmanMsg.g


#ifndef __INET_BATMANMSG_H
#define __INET_BATMANMSG_H

#include "inet/common/INETDefs.h"

#include "BatmanMsg_m.h"

inline bool operator < (HnaElement const &a, HnaElement const &b)
{
    return (a.addr < b.addr) || (a.addr == b.addr && a.netmask < b.netmask);
}

inline bool operator > (HnaElement const &a, HnaElement const &b)
{
    return (a.addr > b.addr) || (a.addr == b.addr && a.netmask > b.netmask);
}

inline bool operator == (HnaElement const &a, HnaElement const &b)
{
    return (a.addr == b.addr && a.netmask == b.netmask);
}

inline bool operator != (HnaElement const &a, HnaElement const &b)
{
    return !(a.addr == b.addr && a.netmask == b.netmask);
}

#endif
