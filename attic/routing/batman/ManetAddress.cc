// PowerRouting for OMNeT++ - Batman ManetAddress
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, ManetAddress.cc


#include "ManetAddress.h"

typedef inet::IPv4Address IPv4Address;
typedef inet::IPv6Address IPv6Address;
typedef inet::L3Address L3Address;
typedef inet::MACAddress MACAddress;

void ManetNetworkAddress::set(IPv4Address addr, short unsigned int masklen)
{
    IPv4Address maskedAddr = addr;
    maskedAddr.doAnd(IPv4Address::makeNetmask(masklen));
    address.set(maskedAddr);
    prefixLength = masklen;
}

void ManetNetworkAddress::set(const IPv6Address& addr, short unsigned int masklen)
{
    IPv6Address maskedAddr = addr.getPrefix(masklen);
    address.set(maskedAddr);
    prefixLength = masklen;
}

void ManetNetworkAddress::set(const L3Address& addr)
{
    if (addr.getType() == L3Address::IPv6)
        set(addr.toIPv6());
    else
        set(addr.toIPv4());
}

void ManetNetworkAddress::set(const L3Address& addr, short unsigned int masklen)
{
    if (addr.getType() == L3Address::IPv6)
        set(addr.toIPv6(), masklen);
    else
        set(addr.toIPv4(), masklen);
}

void ManetNetworkAddress::set(MACAddress addr, short unsigned int masklen)
{
    if (masklen != 48)
        throw cRuntimeError("mask not supported for MACAddress");
    address.set(addr);
    prefixLength = masklen;
}

void ManetNetworkAddress::setPrefixLen(short unsigned int masklen)
{
    address = address.getPrefix(masklen);
    prefixLength = masklen;
}

short int ManetNetworkAddress::compare(const ManetNetworkAddress& other) const
{
    if (getType() < other.getType())
        return -1;
    if (getType() > other.getType())
        return 1;
    if (prefixLength > other.prefixLength)
        return -1;
    if (prefixLength < other.prefixLength)
        return 1;
    if (address < other.address)
        return -1;
    if (other.address < address)
        return 1;
    return 0;
}

std::string ManetNetworkAddress::str() const
{
    std::ostringstream ss;
    ss << address << '/' << prefixLength;
    return ss.str();
}

bool ManetNetworkAddress::contains(const L3Address& other) const
{
    if (getType() == other.getType())
    {
        ManetNetworkAddress tmp(other, prefixLength);
        return (*this == tmp);
    }
    return false;
}

bool ManetNetworkAddress::contains(const ManetNetworkAddress& other) const
{
    if (getType() == other.getType() && prefixLength <= other.prefixLength)
    {
        ManetNetworkAddress tmp(other.address, prefixLength);
        return (*this == tmp);
    }
    return false;
}


