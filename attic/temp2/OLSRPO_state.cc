/***************************************************************************
 *   Copyright (C) 2004 by Francisco J. Ros                                *
 *   fjrm@dif.um.es                                                        *
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
/// \file   OLSRPO_state.cc
/// \brief  Implementation of all functions needed for manipulating the internal
///     state of an OLSRPO node.
///

#include "OLSRPO_state.h"
#include "OLSRPO.h"

//namespace inet {
//
//namespace inetmanet {

/********** MPR Selector Set Manipulation **********/

OLSRPO_mprsel_tuple*
OLSRPO_state::find_mprsel_tuple(const nsaddr_t &main_addr)
{
    for (auto it = mprselset_.begin(); it != mprselset_.end(); it++)
    {
        OLSRPO_mprsel_tuple* tuple = *it;
        if (tuple->main_addr() == main_addr)
            return tuple;
    }
    return nullptr;
}

void
OLSRPO_state::erase_mprsel_tuple(OLSRPO_mprsel_tuple* tuple)
{
    for (auto it = mprselset_.begin(); it != mprselset_.end(); it++)
    {
        if (*it == tuple)
        {
            mprselset_.erase(it);
            break;
        }
    }
}

bool
OLSRPO_state::erase_mprsel_tuples(const nsaddr_t & main_addr)
{
    bool topologyChanged = false;
    for (auto it = mprselset_.begin(); it != mprselset_.end();)
    {
        OLSRPO_mprsel_tuple* tuple = *it;
        if (tuple->main_addr() == main_addr)
        {
            it = mprselset_.erase(it);
            topologyChanged = true;
            if (mprselset_.empty())
                break;
        }
        else
            it++;

    }
    return topologyChanged;
}

void
OLSRPO_state::insert_mprsel_tuple(OLSRPO_mprsel_tuple* tuple)
{
    mprselset_.push_back(tuple);
}

/********** Neighbor Set Manipulation **********/

OLSRPO_nb_tuple*
OLSRPO_state::find_nb_tuple(const nsaddr_t & main_addr)
{
    for (auto it = nbset_.begin(); it != nbset_.end(); it++)
    {
        OLSRPO_nb_tuple* tuple = *it;
        if (tuple->nb_main_addr() == main_addr)
            return tuple;
    }
    return nullptr;
}

OLSRPO_nb_tuple*
OLSRPO_state::find_sym_nb_tuple(const nsaddr_t & main_addr)
{
    for (auto it = nbset_.begin(); it != nbset_.end(); it++)
    {
        OLSRPO_nb_tuple* tuple = *it;
        if (tuple->nb_main_addr() == main_addr && tuple->getStatus() == OLSRPO_STATUS_SYM)
            return tuple;
    }
    return nullptr;
}

OLSRPO_nb_tuple*
OLSRPO_state::find_nb_tuple(const nsaddr_t & main_addr, uint8_t willingness)
{
    for (auto it = nbset_.begin(); it != nbset_.end(); it++)
    {
        OLSRPO_nb_tuple* tuple = *it;
        if (tuple->nb_main_addr() == main_addr && tuple->willingness() == willingness)
            return tuple;
    }
    return nullptr;
}

void
OLSRPO_state::erase_nb_tuple(OLSRPO_nb_tuple* tuple)
{
    for (auto it = nbset_.begin(); it != nbset_.end(); it++)
    {
        if (*it == tuple)
        {
            nbset_.erase(it);
            break;
        }
    }
}

void
OLSRPO_state::erase_nb_tuple(const nsaddr_t & main_addr)
{
    for (auto it = nbset_.begin(); it != nbset_.end(); it++)
    {
        OLSRPO_nb_tuple* tuple = *it;
        if (tuple->nb_main_addr() == main_addr)
        {
            it = nbset_.erase(it);
            break;
        }
    }
}

void
OLSRPO_state::insert_nb_tuple(OLSRPO_nb_tuple* tuple)
{
    nbset_.push_back(tuple);
}

/********** Neighbor 2 Hop Set Manipulation **********/

OLSRPO_nb2hop_tuple*
OLSRPO_state::find_nb2hop_tuple(const nsaddr_t & nb_main_addr, const nsaddr_t & nb2hop_addr)
{
    for (auto it = nb2hopset_.begin(); it != nb2hopset_.end(); it++)
    {
        OLSRPO_nb2hop_tuple* tuple = *it;
        if (tuple->nb_main_addr() == nb_main_addr && tuple->nb2hop_addr() == nb2hop_addr)
            return tuple;
    }
    return nullptr;
}

void
OLSRPO_state::erase_nb2hop_tuple(OLSRPO_nb2hop_tuple* tuple)
{
    for (auto it = nb2hopset_.begin(); it != nb2hopset_.end(); it++)
    {
        if (*it == tuple)
        {
            nb2hopset_.erase(it);
            break;
        }
    }
}

bool
OLSRPO_state::erase_nb2hop_tuples(const nsaddr_t & nb_main_addr, const nsaddr_t & nb2hop_addr)
{
    bool returnValue = false;
    for (auto it = nb2hopset_.begin(); it != nb2hopset_.end();)
    {
        OLSRPO_nb2hop_tuple* tuple = *it;
        if (tuple->nb_main_addr() == nb_main_addr && tuple->nb2hop_addr() == nb2hop_addr)
        {
            it = nb2hopset_.erase(it);
            returnValue = true;
            if (nb2hopset_.empty())
                break;
        }
        else
            it++;

    }
    return returnValue;
}

bool
OLSRPO_state::erase_nb2hop_tuples(const nsaddr_t & nb_main_addr)
{
    bool topologyChanged = false;
    for (auto it = nb2hopset_.begin(); it != nb2hopset_.end();)
    {
        OLSRPO_nb2hop_tuple* tuple = *it;
        if (tuple->nb_main_addr() == nb_main_addr)
        {
            it = nb2hopset_.erase(it);
            topologyChanged = true;
            if (nb2hopset_.empty())
                break;
        }
        else
            it++;

    }
    return topologyChanged;
}

void
OLSRPO_state::insert_nb2hop_tuple(OLSRPO_nb2hop_tuple* tuple)
{
    nb2hopset_.push_back(tuple);
}

/********** MPR Set Manipulation **********/

bool
OLSRPO_state::find_mpr_addr(const nsaddr_t & addr)
{
    auto it = mprset_.find(addr);
    return (it != mprset_.end());
}

void
OLSRPO_state::insert_mpr_addr(const nsaddr_t & addr)
{
    mprset_.insert(addr);
}

void
OLSRPO_state::clear_mprset()
{
    mprset_.clear();
}

/********** Duplicate Set Manipulation **********/

OLSRPO_dup_tuple*
OLSRPO_state::find_dup_tuple(const nsaddr_t & addr, uint16_t seq_num)
{
    for (auto it = dupset_.begin(); it != dupset_.end(); it++)
    {
        OLSRPO_dup_tuple* tuple = *it;
        if (tuple->getAddr() == addr && tuple->seq_num() == seq_num)
            return tuple;
    }
    return nullptr;
}

void
OLSRPO_state::erase_dup_tuple(OLSRPO_dup_tuple* tuple)
{
    for (auto it = dupset_.begin(); it != dupset_.end(); it++)
    {
        if (*it == tuple)
        {
            dupset_.erase(it);
            break;
        }
    }
}

void
OLSRPO_state::insert_dup_tuple(OLSRPO_dup_tuple* tuple)
{
    dupset_.push_back(tuple);
}

/********** Link Set Manipulation **********/

OLSRPO_link_tuple*
OLSRPO_state::find_link_tuple(const nsaddr_t & iface_addr)
{
    for (auto it = linkset_.begin(); it != linkset_.end(); it++)
    {
        OLSRPO_link_tuple* tuple = *it;
        if (tuple->nb_iface_addr() == iface_addr)
            return tuple;
    }
    return nullptr;
}

OLSRPO_link_tuple*
OLSRPO_state::find_sym_link_tuple(const nsaddr_t & iface_addr, double now)
{
    for (auto it = linkset_.begin(); it != linkset_.end(); it++)
    {
        OLSRPO_link_tuple* tuple = *it;
        if (tuple->nb_iface_addr() == iface_addr)
        {
            if (tuple->sym_time() > now)
                return tuple;
            else
                break;
        }
    }
    return nullptr;
}

void
OLSRPO_state::erase_link_tuple(OLSRPO_link_tuple* tuple)
{
    for (auto it = linkset_.begin(); it != linkset_.end(); it++)
    {
        if (*it == tuple)
        {
            linkset_.erase(it);
            break;
        }
    }
}

void
OLSRPO_state::insert_link_tuple(OLSRPO_link_tuple* tuple)
{
    linkset_.push_back(tuple);
}

/********** Topology Set Manipulation **********/

OLSRPO_topology_tuple*
OLSRPO_state::find_topology_tuple(const nsaddr_t & dest_addr, const nsaddr_t & last_addr)
{
    for (auto it = topologyset_.begin(); it != topologyset_.end(); it++)
    {
        OLSRPO_topology_tuple* tuple = *it;
        if (tuple->dest_addr() == dest_addr && tuple->last_addr() == last_addr)
            return tuple;
    }
    return nullptr;
}

OLSRPO_topology_tuple*
OLSRPO_state::find_newer_topology_tuple(const nsaddr_t &last_addr, uint16_t ansn)
{
    for (auto it = topologyset_.begin(); it != topologyset_.end(); it++)
    {
        OLSRPO_topology_tuple* tuple = *it;
        if (tuple->last_addr() == last_addr && tuple->seq() > ansn)
            return tuple;
    }
    return nullptr;
}

void
OLSRPO_state::erase_topology_tuple(OLSRPO_topology_tuple* tuple)
{
    for (auto it = topologyset_.begin(); it != topologyset_.end(); it++)
    {
        if (*it == tuple)
        {
            topologyset_.erase(it);
            break;
        }
    }
}
std::ostream& operator<<(std::ostream& out, const OLSRPO_topology_tuple& tuple)
{
    out << "Tuple index: " << tuple.index;
    out << " dest: "<< tuple.dest_addr_;
    out << " last: " << tuple.last_addr_;
    out << " seq: " << tuple.seq_;
    out << " time: " << tuple.time_;
    out << std::endl;
    return out;
}
void
OLSRPO_state::print_topology_tuples_to(const nsaddr_t & dest_addr)
{
    for (auto it = topologyset_.begin(); it != topologyset_.end(); it++)
    {
        OLSRPO_topology_tuple* tuple = *it;
        if (tuple->dest_addr() == dest_addr)
            std::cout << " -- " << *tuple;
    }
}


void
OLSRPO_state::print_topology_tuples_across(const nsaddr_t & last_addr)
{
    for (auto it = topologyset_.begin(); it != topologyset_.end(); it++)
    {
        OLSRPO_topology_tuple* tuple = *it;
        if (tuple->last_addr() == last_addr)
            std::cout << " -- " << *tuple;
    }
}
void
OLSRPO_state::erase_older_topology_tuples(const nsaddr_t & last_addr, uint16_t ansn)
{
    for (auto it = topologyset_.begin(); it != topologyset_.end();)
    {
        OLSRPO_topology_tuple* tuple = *it;
        if (tuple->last_addr() == last_addr && tuple->seq() < ansn)
        {
            it = topologyset_.erase(it);
            if (topologyset_.empty())
                break;
        }
        else
            it++;

    }
}

void
OLSRPO_state::insert_topology_tuple(OLSRPO_topology_tuple* tuple)
{
    topologyset_.push_back(tuple);
}

/********** Interface Association Set Manipulation **********/

OLSRPO_iface_assoc_tuple*
OLSRPO_state::find_ifaceassoc_tuple(const nsaddr_t & iface_addr)
{
    for (auto it = ifaceassocset_.begin();
            it != ifaceassocset_.end();
            it++)
    {
        OLSRPO_iface_assoc_tuple* tuple = *it;
        if (tuple->iface_addr() == iface_addr)
            return tuple;
    }
    return nullptr;
}

void
OLSRPO_state::erase_ifaceassoc_tuple(OLSRPO_iface_assoc_tuple* tuple)
{
    for (auto it = ifaceassocset_.begin();
            it != ifaceassocset_.end();
            it++)
    {
        if (*it == tuple)
        {
            ifaceassocset_.erase(it);
            break;
        }
    }
}

void
OLSRPO_state::insert_ifaceassoc_tuple(OLSRPO_iface_assoc_tuple* tuple)
{
    ifaceassocset_.push_back(tuple);
}

void OLSRPO_state::clear_all()
{

    for (auto it = linkset_.begin(); it != linkset_.end(); it++)
        delete (*it);
    linkset_.clear();

    for (auto it = nbset_.begin(); it != nbset_.end(); it++)
        delete (*it);
    nbset_.clear();
    for (auto it = nb2hopset_.begin(); it != nb2hopset_.end(); it++)
        delete (*it);
    nb2hopset_.clear();
    for (auto it = topologyset_.begin(); it != topologyset_.end(); it++)
        delete (*it);
    topologyset_.clear();

    for (auto it = mprselset_.begin(); it != mprselset_.end(); it++)
        delete (*it);
    mprselset_.clear();
    for (auto it = dupset_.begin(); it != dupset_.end(); it++)
        delete (*it);

    dupset_.clear();
    for (auto it = ifaceassocset_.begin(); it != ifaceassocset_.end(); it++)
        delete (*it);
    ifaceassocset_.clear();
    mprset_.clear();

}

OLSRPO_state::OLSRPO_state(const OLSRPO_state& st)
{
    for (auto it = st.linkset_.begin(); it != st.linkset_.end(); it++)
    {
        OLSRPO_link_tuple* tuple = *it;
        linkset_.push_back(tuple->dup());
    }

    for (auto it = st.nbset_.begin(); it != st.nbset_.end(); it++)
    {
        OLSRPO_nb_tuple* tuple = *it;
        nbset_.push_back(tuple->dup());
    }

    for (auto it = st.nb2hopset_.begin(); it != st.nb2hopset_.end(); it++)
    {
        OLSRPO_nb2hop_tuple* tuple = *it;
        nb2hopset_.push_back(tuple->dup());
    }

    for (auto it = st.topologyset_.begin(); it != st.topologyset_.end(); it++)
    {
        OLSRPO_topology_tuple* tuple = *it;
        topologyset_.push_back(tuple->dup());
    }

    for (auto it = st.mprset_.begin(); it != st.mprset_.end(); it++)
    {
        mprset_.insert(*it);
    }

    for (auto it = st.mprselset_.begin(); it != st.mprselset_.end(); it++)
    {
        OLSRPO_mprsel_tuple* tuple = *it;
        mprselset_.push_back(tuple->dup());
    }

    for (auto it = st.dupset_.begin(); it != st.dupset_.end(); it++)
    {
        OLSRPO_dup_tuple* tuple = *it;
        dupset_.push_back(tuple->dup());
    }

    for (auto it = st.ifaceassocset_.begin(); it != st.ifaceassocset_.end(); it++)
    {
        OLSRPO_iface_assoc_tuple* tuple = *it;
        ifaceassocset_.push_back(tuple->dup());
    }
}


OLSRPO_state::~OLSRPO_state()
{
    clear_all();
}

//} // namespace inetmanet
//
//} // namespace inet

