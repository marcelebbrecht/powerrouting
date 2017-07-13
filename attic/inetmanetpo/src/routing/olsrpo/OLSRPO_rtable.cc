/***************************************************************************
 *   Copyright (C) 2004 by Francisco J. Ros                                *
 *   fjrm@dif.um.es                                                        *
 *   Adapted for omnetpp                                                   *
 *   2008 Alfonso Ariza Quintana aarizaq@uma.es                            *
 *                                                                         *
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
/// \file   OLSRPO_rtable.cc
/// \brief  Implementation of our routing table.
///

#include "inet/routing/extras/olsrpo/OLSRPO.h"
#include "inet/routing/extras/olsrpo/OLSRPO_rtable.h"
#include "inet/routing/extras/olsrpo/OLSRPO_repositories.h"

namespace inet {

namespace inetmanet {

///
/// \brief Creates a new empty routing table.
///
OLSRPO_rtable::OLSRPO_rtable()
{
}

OLSRPO_rtable::OLSRPO_rtable(const OLSRPO_rtable& rtable)
{
    for (rtable_t::const_iterator itRtTable = rtable.getInternalTable()->begin();itRtTable != rtable.getInternalTable()->begin();++itRtTable)
    {
        rt_[itRtTable->first] = itRtTable->second->dup();
    }
}

///
/// \brief Destroys the routing table and all its entries.
///
OLSRPO_rtable::~OLSRPO_rtable()
{
    // Iterates over the routing table deleting each OLSRPO_rt_entry*.
    for (auto it = rt_.begin(); it != rt_.end(); it++)
        delete (*it).second;
}

///
/// \brief Clears the routing table and frees the memory assigned to each one of its entries.
///
void
OLSRPO_rtable::clear()
{
    // Iterates over the routing table deleting each OLSRPO_rt_entry*.
    for (auto it = rt_.begin(); it != rt_.end(); it++)
        delete (*it).second;

    // Cleans routing table.
    rt_.clear();
}

///
/// \brief Deletes the entry whose destination address is given.
/// \param dest address of the destination node.
///
void
OLSRPO_rtable::rm_entry(const nsaddr_t &dest)
{
    // Remove the pair whose key is dest
    rt_.erase(dest);
}

///
/// \brief Looks up an entry for the specified destination address.
/// \param dest destination address.
/// \return the routing table entry for that destination address, or nullptr
///     if such an entry does not exist
///
OLSRPO_rt_entry*
OLSRPO_rtable::lookup(const nsaddr_t &dest)
{
    // Get the iterator at "dest" position
    auto it = rt_.find(dest);
    // If there is no route to "dest", return nullptr
    if (it == rt_.end())
        return nullptr;

    // Returns the rt entry (second element of the pair)
    return (*it).second;
}

///
/// \brief  Finds the appropiate entry which must be used in order to forward
///     a data packet to a next hop (given a destination).
///
/// Imagine a routing table like this: [A,B] [B,C] [C,C]; being each pair of the
/// form [dest addr,next-hop addr]. In this case, if this function is invoked with
/// [A,B] then pair [C,C] is returned because C is the next hop that must be used
/// to forward a data packet destined to A. That is, C is a neighbor of this node,
/// but B isn't. This function finds the appropiate neighbor for forwarding a packet.
///
/// \param entry    the routing table entry which indicates the destination node
///         we are interested in.
/// \return     the appropiate routing table entry which indicates the next
///         hop which must be used for forwarding a data packet, or nullptr
///         if there is no such entry.
///
OLSRPO_rt_entry*
OLSRPO_rtable::find_send_entry(OLSRPO_rt_entry* entry)
{
    OLSRPO_rt_entry* e = entry;
    while (e != nullptr && e->dest_addr() != e->next_addr())
        e = lookup(e->next_addr());
    return e;
}

///
/// \brief Adds a new entry into the routing table.
///
/// If an entry for the given destination existed, it is deleted and freed.
///
/// \param dest     address of the destination node.
/// \param next     address of the next hop node.
/// \param iface    address of the local interface.
/// \param dist     distance to the destination node.
/// \return     the routing table entry which has been added.
///
OLSRPO_rt_entry*
OLSRPO_rtable::add_entry(const nsaddr_t &dest, const nsaddr_t & next, const nsaddr_t & iface, uint32_t dist, const int &index, double quality, double delay)
{
    // Creates a new rt entry with specified values
    OLSRPO_rt_entry* entry = new OLSRPO_rt_entry();
    entry->dest_addr() = dest;
    entry->next_addr() = next;
    entry->iface_addr() = iface;
    entry->dist() = dist;
    entry->quality = quality;
    entry->delay = delay;
    entry->local_iface_index() = index;
    if (entry->dist()==2)
    {
        entry->route.push_back(next);
    }

    // Inserts the new entry
    auto it = rt_.find(dest);
    if (it != rt_.end())
        delete (*it).second;
    rt_[dest] = entry;

    // Returns the new rt entry
    return entry;
}

OLSRPO_rt_entry*
OLSRPO_rtable::add_entry(const nsaddr_t & dest, const nsaddr_t & next, const nsaddr_t & iface, uint32_t dist, const int &index, OLSRPO_rt_entry *entryAux, double quality, double delay)
{
    // Creates a new rt entry with specified values
    OLSRPO_rt_entry* entry = new OLSRPO_rt_entry();
    entry->dest_addr() = dest;
    entry->next_addr() = next;
    entry->iface_addr() = iface;
    entry->dist() = dist;
    entry->quality = quality;
    entry->delay = delay;
    entry->local_iface_index() = index;
    entry->route = entryAux->route;
    if (entryAux->dist()==(entry->dist()-1))
        entry->route.push_back(entryAux->dest_addr());

    // Inserts the new entry
    auto it = rt_.find(dest);
    if (it != rt_.end())
        delete (*it).second;
    rt_[dest] = entry;

    // Returns the new rt entry
    return entry;
}


///
/// \brief Returns the number of entries in the routing table.
/// \return the number of entries in the routing table.
///
uint32_t
OLSRPO_rtable::size()
{
    return rt_.size();
}

///
/// \brief Prints out the content of the routing table
///
/// Content is represented as a table in which each line is preceeded by a 'P'.
/// First line contains the name of every column (dest, next, iface, dist)
/// and the following ones are the values of each entry.
///
///

std::string OLSRPO_rtable::detailedInfo() const
{
    std::stringstream out;

    for (auto it = rt_.begin(); it != rt_.end(); it++)
    {
        OLSRPO_rt_entry* entry = dynamic_cast<OLSRPO_rt_entry *> ((*it).second);
        out << "dest:"<< OLSRPO::node_id(entry->dest_addr()) << " ";
        out << "gw:" << OLSRPO::node_id(entry->next_addr()) << " ";
        out << "iface:" << OLSRPO::node_id(entry->iface_addr()) << " ";
        out << "dist:" << entry->dist() << " ";
        out <<"\n";
    }
    return out.str();
}

} // namespace inetmanet

} // namespace inet

