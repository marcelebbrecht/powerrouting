/***************************************************************************
 *   Copyright (C) 2004 by Francisco J. Ros                                *
 *   fjrm@dif.um.es                                                        *
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
/// \file   OLSRPO_printer.h
/// \brief  Header file which includes all printing functions related to OLSRPO.
///

//#ifndef __OLSRPO_printer_h__
#define __OLSRPO_printer_h__

#include "OLSRPO.h"
#include "OLSRPOpkt_m.h"
#include "OLSRPO_repositories.h"

#if 0
#include <packet.h>
#include <ip.h>
#include <trace.h>
#endif

//namespace inet {
//
//namespace inetmanet {

/// Encapsulates all printing functions for OLSRPO data structures and messages.
class OLSRPO_printer
{
    friend class OLSRPO;

  protected:
    static void print_linkset(Trace*, linkset_t&);
    static void print_nbset(Trace*, nbset_t&);
    static void print_nb2hopset(Trace*, nb2hopset_t&);
    static void print_mprset(Trace*, mprset_t&);
    static void print_mprselset(Trace*, mprselset_t&);
    static void print_topologyset(Trace*, topologyset_t&);

    static void print_olsr_pkt(FILE*, OLSRPO_pkt*);
    static void print_olsr_msg(FILE*, OLSRPO_msg&);
    static void print_olsr_hello(FILE*, OLSRPO_hello&);
    static void print_olsr_tc(FILE*, OLSRPO_tc&);
    static void print_olsr_mid(FILE*, OLSRPO_mid&);
#if 0
  public:
    static void print_cmn_hdr(FILE*, struct hdr_cmn*);
    static void print_ip_hdr(FILE*, struct hdr_ip*);
#endif
};

//} // namespace inetmanet
//
//} // namespace inet

//#endif

