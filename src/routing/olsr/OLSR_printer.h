// PowerRouting for OMNeT++ - OLSR printer
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, OLSR_printer.h

#ifndef __OLSR_printer_h__
#define __OLSR_printer_h__

#include "OLSR.h"
#include "OLSRpkt_m.h"
#include "OLSR_repositories.h"

#if 0
#include <packet.h>
#include <ip.h>
#include <trace.h>
#endif

/// Encapsulates all printing functions for OLSR data structures and messages.
class OLSR_printer
{
    friend class OLSR;

  protected:
    static void print_linkset(Trace*, linkset_t&);
    static void print_nbset(Trace*, nbset_t&);
    static void print_nb2hopset(Trace*, nb2hopset_t&);
    static void print_mprset(Trace*, mprset_t&);
    static void print_mprselset(Trace*, mprselset_t&);
    static void print_topologyset(Trace*, topologyset_t&);

    static void print_olsr_pkt(FILE*, OLSR_pkt*);
    static void print_olsr_msg(FILE*, OLSR_msg&);
    static void print_olsr_hello(FILE*, OLSR_hello&);
    static void print_olsr_tc(FILE*, OLSR_tc&);
    static void print_olsr_mid(FILE*, OLSR_mid&);
#if 0
  public:
    static void print_cmn_hdr(FILE*, struct hdr_cmn*);
    static void print_ip_hdr(FILE*, struct hdr_ip*);
#endif
};

#endif

