// PowerRouting for OMNeT++ - AODV route data
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, AODVRouteData.h

#ifndef __INET_AODVROUTEDATA_H
#define __INET_AODVROUTEDATA_H

#include <set>
#include "inet/networklayer/common/L3Address.h"
#include "inet/common/INETDefs.h"

// typedefs for porting
typedef inet::L3Address L3Address;

//class INET_API AODVRouteData : public cObject
class AODVRouteData : public cObject
{
  protected:
    std::set<L3Address> precursorList;
    bool active;
    bool repariable;
    bool beingRepaired;
    bool validDestNum;
    unsigned int destSeqNum;
    simtime_t lifeTime;    // expiration or deletion time of the route

  public:

    AODVRouteData()
    {
        active = true;
        repariable = false;
        beingRepaired = false;
        validDestNum = true;
        lifeTime = SIMTIME_ZERO;
        destSeqNum = 0;
    }

    virtual ~AODVRouteData() {}

    unsigned int getDestSeqNum() const { return destSeqNum; }
    void setDestSeqNum(unsigned int destSeqNum) { this->destSeqNum = destSeqNum; }
    bool hasValidDestNum() const { return validDestNum; }
    void setHasValidDestNum(bool hasValidDestNum) { this->validDestNum = hasValidDestNum; }
    bool isBeingRepaired() const { return beingRepaired; }
    void setIsBeingRepaired(bool isBeingRepaired) { this->beingRepaired = isBeingRepaired; }
    bool isRepariable() const { return repariable; }
    void setIsRepariable(bool isRepariable) { this->repariable = isRepariable; }
    const simtime_t& getLifeTime() const { return lifeTime; }
    void setLifeTime(const simtime_t& lifeTime) { this->lifeTime = lifeTime; }
    bool isActive() const { return active; }
    void setIsActive(bool active) { this->active = active; }
    void addPrecursor(const L3Address& precursorAddr) { precursorList.insert(precursorAddr); }
    const std::set<L3Address>& getPrecursorList() const { return precursorList; }
};

std::ostream& operator<<(std::ostream& out, const AODVRouteData *data);

#endif    // ifndef AODVROUTEDATA_H_

