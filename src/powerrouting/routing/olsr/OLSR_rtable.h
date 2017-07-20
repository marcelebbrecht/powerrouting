// PowerRouting for OMNeT++ - OLSR rtable
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, OLSR_rtable.h

#ifndef __OLSR_rtable_h__
#define __OLSR_rtable_h__

#include <map>
#include "inet/common/INETDefs.h"
#include "OLSR_repositories.h"

///
/// \brief Defines rtable_t as a map of OLSR_rt_entry, whose key is the destination address.
///
/// The routing table is thus defined as pairs: [dest address, entry]. Each element
/// of the pair can be accesed via "first" and "second" members.
///
typedef std::map<nsaddr_t, OLSR_rt_entry*> rtable_t;

///
/// \brief This class is a representation of the OLSR's Routing Table.
///
class OLSR_rtable : public cObject
{

  public:
    rtable_t    rt_;    ///< Data structure for the routing table.

    OLSR_rtable(const OLSR_rtable& other);
    OLSR_rtable();
    ~OLSR_rtable();
    const rtable_t * getInternalTable() const { return &rt_; }


    void        clear();
    void        rm_entry(const nsaddr_t &dest);
    OLSR_rt_entry*  add_entry(const nsaddr_t &dest, const nsaddr_t &next, const nsaddr_t &iface, uint32_t dist, const int &, double quality = -1, double delay = -1);
    OLSR_rt_entry*  add_entry(const nsaddr_t &dest, const nsaddr_t &next, const nsaddr_t &iface, uint32_t dist, const int &, PathVector path, double quality = -1, double delay = -1);
    OLSR_rt_entry*  add_entry(const nsaddr_t &dest, const nsaddr_t &next, const nsaddr_t &iface, uint32_t dist, const int &, OLSR_rt_entry *entry, double quality = -1, double delay = -1);
    OLSR_rt_entry*  lookup(const nsaddr_t &dest);
    OLSR_rt_entry*  find_send_entry(OLSR_rt_entry*);
    uint32_t    size();

    virtual std::string detailedInfo() const;

    virtual OLSR_rtable *dup() const { return new OLSR_rtable(*this); }

//  void        print(Trace*);
};

#endif

