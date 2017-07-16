// PowerRouting for OMNeT++ - OLSR state
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, OLSR_state.h

#ifndef __OLSR_state_h__
#define __OLSR_state_h__

#include "inet/common/INETDefs.h"
#include "OLSR_repositories.h"

/// This class encapsulates all data structures needed for maintaining internal state of an OLSR node.
class OLSR_state : public cObject
{
    friend class OLSR;
    friend class OLSROPT;
    friend class OLSRPO;
  protected:
    linkset_t   linkset_;   ///< Link Set (RFC 3626, section 4.2.1).
    nbset_t     nbset_;     ///< Neighbor Set (RFC 3626, section 4.3.1).
    nb2hopset_t nb2hopset_; ///< 2-hop Neighbor Set (RFC 3626, section 4.3.2).
    topologyset_t   topologyset_;   ///< Topology Set (RFC 3626, section 4.4).
    mprset_t    mprset_;    ///< MPR Set (RFC 3626, section 4.3.3).
    mprselset_t mprselset_; ///< MPR Selector Set (RFC 3626, section 4.3.4).
    dupset_t    dupset_;    ///< Duplicate Set (RFC 3626, section 3.4).
    ifaceassocset_t ifaceassocset_; ///< Interface Association Set (RFC 3626, section 4.1).

    inline  linkset_t&      linkset()   { return linkset_; }
    inline  mprset_t&       mprset()    { return mprset_; }
    inline  mprselset_t&        mprselset() { return mprselset_; }
    inline  nbset_t&        nbset()     { return nbset_; }
    inline  nb2hopset_t&        nb2hopset() { return nb2hopset_; }
    inline  topologyset_t&      topologyset()   { return topologyset_; }
    inline  dupset_t&       dupset()    { return dupset_; }
    inline  ifaceassocset_t&    ifaceassocset() { return ifaceassocset_; }

    OLSR_mprsel_tuple*  find_mprsel_tuple(const nsaddr_t &);
    void            erase_mprsel_tuple(OLSR_mprsel_tuple*);
    bool            erase_mprsel_tuples(const nsaddr_t &);
    void            insert_mprsel_tuple(OLSR_mprsel_tuple*);

    OLSR_nb_tuple*      find_nb_tuple(const nsaddr_t &);
    OLSR_nb_tuple*      find_sym_nb_tuple(const nsaddr_t &);
    OLSR_nb_tuple*      find_nb_tuple(const nsaddr_t &, uint8_t);
    void            erase_nb_tuple(OLSR_nb_tuple*);
    void            erase_nb_tuple(const nsaddr_t &);
    void            insert_nb_tuple(OLSR_nb_tuple*);

    OLSR_nb2hop_tuple*  find_nb2hop_tuple(const nsaddr_t &, const nsaddr_t &);
    void            erase_nb2hop_tuple(OLSR_nb2hop_tuple*);
    bool            erase_nb2hop_tuples(const nsaddr_t &);
    bool            erase_nb2hop_tuples(const nsaddr_t &, const nsaddr_t &);
    void            insert_nb2hop_tuple(OLSR_nb2hop_tuple*);

    bool            find_mpr_addr(const nsaddr_t&);
    void            insert_mpr_addr(const nsaddr_t&);
    void            clear_mprset();

    OLSR_dup_tuple*     find_dup_tuple(const nsaddr_t &, uint16_t);
    void            erase_dup_tuple(OLSR_dup_tuple*);
    void            insert_dup_tuple(OLSR_dup_tuple*);

    OLSR_link_tuple*    find_link_tuple(const nsaddr_t &);
    OLSR_link_tuple*    find_sym_link_tuple(const nsaddr_t &, double);
    void            erase_link_tuple(OLSR_link_tuple*);
    void            insert_link_tuple(OLSR_link_tuple*);

    OLSR_topology_tuple*    find_topology_tuple(const nsaddr_t &, const  nsaddr_t &);
    OLSR_topology_tuple*    find_newer_topology_tuple(const nsaddr_t &, uint16_t);
    void            erase_topology_tuple(OLSR_topology_tuple*);
    void            erase_older_topology_tuples(const nsaddr_t &, uint16_t);
    void             print_topology_tuples_to(const nsaddr_t & dest_addr);
    void             print_topology_tuples_across(const nsaddr_t & last_addr);
    void            insert_topology_tuple(OLSR_topology_tuple*);

    OLSR_iface_assoc_tuple* find_ifaceassoc_tuple(const nsaddr_t&);
    void            erase_ifaceassoc_tuple(OLSR_iface_assoc_tuple*);
    void            insert_ifaceassoc_tuple(OLSR_iface_assoc_tuple*);
    void            clear_all();

    OLSR_state() {}
    ~OLSR_state();
    OLSR_state(const OLSR_state &);
    virtual OLSR_state * dup() const { return new OLSR_state(*this); }
};

//} // namespace inetmanet
//
//} // namespace inet

#endif

