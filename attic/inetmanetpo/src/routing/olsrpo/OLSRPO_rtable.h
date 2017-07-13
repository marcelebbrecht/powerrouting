/***************************************************************************
 *   Copyright (C) 2004 by Francisco J. Ros                                *
 *   fjrm@dif.um.es                                                        *
 *                                                                         *
 *   Adapted for omnetpp                                                   *
 *   2008 Alfonso Ariza Quintana aarizaq@uma.es                            *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/

///
/// \file   OLSRPO_rtable.h
/// \brief  Header file for routing table's related stuff.
///

#ifndef __OLSRPO_rtable_h__
#define __OLSRPO_rtable_h__

#include <map>

#include "inet/common/INETDefs.h"

#include "inet/routing/extras/olsrpo/OLSRPO_repositories.h"

namespace inet {

namespace inetmanet {

///
/// \brief Defines rtable_t as a map of OLSRPO_rt_entry, whose key is the destination address.
///
/// The routing table is thus defined as pairs: [dest address, entry]. Each element
/// of the pair can be accesed via "first" and "second" members.
///
typedef std::map<nsaddr_t, OLSRPO_rt_entry*> rtable_t;

///
/// \brief This class is a representation of the OLSRPO's Routing Table.
///
class OLSRPO_rtable : public cObject
{

  public:
    rtable_t    rt_;    ///< Data structure for the routing table.

    OLSRPO_rtable(const OLSRPO_rtable& other);
    OLSRPO_rtable();
    ~OLSRPO_rtable();
    const rtable_t * getInternalTable() const { return &rt_; }


    void        clear();
    void        rm_entry(const nsaddr_t &dest);
    OLSRPO_rt_entry*  add_entry(const nsaddr_t &dest, const nsaddr_t &next, const nsaddr_t &iface, uint32_t dist, const int &, double quality = -1, double delay = -1);
    OLSRPO_rt_entry*  add_entry(const nsaddr_t &dest, const nsaddr_t &next, const nsaddr_t &iface, uint32_t dist, const int &, PathVector path, double quality = -1, double delay = -1);
    OLSRPO_rt_entry*  add_entry(const nsaddr_t &dest, const nsaddr_t &next, const nsaddr_t &iface, uint32_t dist, const int &, OLSRPO_rt_entry *entry, double quality = -1, double delay = -1);
    OLSRPO_rt_entry*  lookup(const nsaddr_t &dest);
    OLSRPO_rt_entry*  find_send_entry(OLSRPO_rt_entry*);
    uint32_t    size();

    virtual std::string detailedInfo() const;

    virtual OLSRPO_rtable *dup() const { return new OLSRPO_rtable(*this); }

//  void        print(Trace*);
};

} // namespace inetmanet

} // namespace inet

#endif

