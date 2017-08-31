// PowerRouting for OMNeT++ - AODV route data
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, AODVRouteData.cc

#include "AODVRouteData.h"

std::ostream& operator<<(std::ostream& out, const AODVRouteData *data)
{
    out << " isActive = " << data->isActive()
        << ", hasValidDestNum = " << data->hasValidDestNum()
        << ", destNum = " << data->getDestSeqNum()
        << ", lifetime = " << data->getLifeTime();

    const std::set<L3Address>& preList = data->getPrecursorList();

    if (!preList.empty()) {
        out << ", precursor list: ";
        std::set<L3Address>::const_iterator iter = preList.begin();
        out << *iter;
        for (++iter; iter != preList.end(); ++iter)
            out << "; " << *iter;
    }
    return out;
};

