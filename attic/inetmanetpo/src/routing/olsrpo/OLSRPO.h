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
/// \file   OLSRPO.h
/// \brief  Header file for OLSRPO agent and related classes.
///
/// Here are defined all timers used by OLSRPO, including those for managing internal
/// state and those for sending messages. Class OLSRPO is also defined, therefore this
/// file has signatures for the most important methods. Lots of constants are also
/// defined.
///

#ifndef __OLSRPO_omnet_h__

#define __OLSRPO_omnet_h__
#include "inet/routing/extras/base/ManetRoutingBase.h"

#include "inet/routing/extras/olsrpo/OLSRPOpkt_m.h"
#include "inet/routing/extras/olsrpo/OLSRPO_state.h"
#include "inet/routing/extras/olsrpo/OLSRPO_rtable.h"
#include "inet/routing/extras/olsrpo/OLSRPO_repositories.h"
#include "inet/common/INETUtils.h"

#include <map>
#include <vector>

#include <assert.h>

namespace inet {

namespace inetmanet {

/********** Useful macros **********/

/// Returns maximum of two numbers.
#ifndef MAX
#define MAX(a, b) (((a) > (b)) ? (a) : (b))
#endif

/// Returns minimum of two numbers.
#ifndef MIN
#define MIN(a, b) (((a) < (b)) ? (a) : (b))
#endif

/// Defines nullptr as zero, used for pointers.
#ifndef nullptr
#define nullptr 0
#endif

#define IP_BROADCAST     ((uint32_t) 0xffffffff)

/// Gets current time from the scheduler.
#ifndef CURRENT_TIME
#define CURRENT_TIME    SIMTIME_DBL(simTime())
#endif

#ifndef CURRENT_TIME_T
#define CURRENT_TIME_T  SIMTIME_DBL(simTime())
#endif

#define debug  EV << utils::stringf



///
/// \brief Gets the delay between a given time and the current time.
///
/// If given time is previous to the current one, then this macro returns
/// a number close to 0. This is used for scheduling events at a certain moment.
///
#define DELAY(time) (((time) < (CURRENT_TIME)) ? (0.000001) : \
    (time - CURRENT_TIME + 0.000001))

#define DELAY_T(time) (((time) < (CURRENT_TIME_T)) ? (0.000001) : \
    (time - CURRENT_TIME_T + 0.000001))


/// Scaling factor used in RFC 3626.
#define OLSRPO_C      0.0625


	/********** Holding times **********/

	/// Neighbor holding time.
#define OLSRPO_NEIGHB_HOLD_TIME   3 * OLSRPO_REFRESH_INTERVAL
	/// Top holding time.
#define OLSRPO_TOP_HOLD_TIME  3 * tc_ival()
	/// Dup holding time.
#define OLSRPO_DUP_HOLD_TIME  30
	/// MID holding time.
#define OLSRPO_MID_HOLD_TIME  3 * mid_ival()

/********** Link types **********/

/// Unspecified link type.
#define OLSRPO_UNSPEC_LINK    0
/// Asymmetric link type.
#define OLSRPO_ASYM_LINK      1
/// Symmetric link type.
#define OLSRPO_SYM_LINK       2
/// Lost link type.
#define OLSRPO_LOST_LINK      3

/********** Neighbor types **********/

/// Not neighbor type.
#define OLSRPO_NOT_NEIGH      0
/// Symmetric neighbor type.
#define OLSRPO_SYM_NEIGH      1
/// Asymmetric neighbor type.
#define OLSRPO_MPR_NEIGH      2


/********** Willingness **********/

/// Willingness for forwarding packets from other nodes: never.
#define OLSRPO_WILL_NEVER     0
/// Willingness for forwarding packets from other nodes: low.
#define OLSRPO_WILL_LOW       1
/// Willingness for forwarding packets from other nodes: medium.
#define OLSRPO_WILL_DEFAULT   3
/// Willingness for forwarding packets from other nodes: high.
#define OLSRPO_WILL_HIGH      6
/// Willingness for forwarding packets from other nodes: always.
#define OLSRPO_WILL_ALWAYS    7


/********** Miscellaneous constants **********/

/// Maximum allowed jitter.
#define OLSRPO_MAXJITTER      hello_ival()/4
/// Maximum allowed sequence number.
#define OLSRPO_MAX_SEQ_NUM    65535
/// Used to set status of an OLSRPO_nb_tuple as "not symmetric".
#define OLSRPO_STATUS_NOT_SYM 0
/// Used to set status of an OLSRPO_nb_tuple as "symmetric".
#define OLSRPO_STATUS_SYM     1
/// Random number between [0-OLSRPO_MAXJITTER] used to jitter OLSRPO packet transmission.
//#define JITTER            (Random::uniform()*OLSRPO_MAXJITTER)

class OLSRPO;         // forward declaration

/********** Timers **********/

/// Basic timer class

class OLSRPO_Timer :  public cOwnedObject /*cMessage*/
{
  protected:
    OLSRPO*       agent_; ///< OLSRPO agent which created the timer.
    cObject* tuple_;
  public:

    virtual void removeTimer();
    OLSRPO_Timer(OLSRPO* agent);
    OLSRPO_Timer();
    ~OLSRPO_Timer();
    virtual void expire() = 0;
    virtual void removeQueueTimer();
    virtual void resched(double time);
    virtual void setTuple(cObject *tuple) {tuple_ = tuple;}
};


/// Timer for sending an enqued message.
class OLSRPO_MsgTimer : public OLSRPO_Timer
{
  public:
    OLSRPO_MsgTimer(OLSRPO* agent) : OLSRPO_Timer(agent) {}
    OLSRPO_MsgTimer():OLSRPO_Timer() {}
    void expire() override;
};

/// Timer for sending HELLO messages.
class OLSRPO_HelloTimer : public OLSRPO_Timer
{
  public:
    OLSRPO_HelloTimer(OLSRPO* agent) : OLSRPO_Timer(agent) {}
    OLSRPO_HelloTimer():OLSRPO_Timer() {}
    void expire() override;
};


/// Timer for sending TC messages.
class OLSRPO_TcTimer : public OLSRPO_Timer
{
  public:
    OLSRPO_TcTimer(OLSRPO* agent) : OLSRPO_Timer(agent) {}
    OLSRPO_TcTimer():OLSRPO_Timer() {}
    void expire() override;
};


/// Timer for sending MID messages.
class OLSRPO_MidTimer : public OLSRPO_Timer
{
  public:
    OLSRPO_MidTimer(OLSRPO* agent) : OLSRPO_Timer(agent) {}
    OLSRPO_MidTimer():OLSRPO_Timer() {}
    virtual void expire() override;
};



/// Timer for removing duplicate tuples: OLSRPO_dup_tuple.
class OLSRPO_DupTupleTimer : public OLSRPO_Timer
{
//  protected:
//  OLSRPO_dup_tuple* tuple_;
  public:
    OLSRPO_DupTupleTimer(OLSRPO* agent, OLSRPO_dup_tuple* tuple) : OLSRPO_Timer(agent)
    {
        tuple_ = tuple;
    }
    void setTuple(OLSRPO_dup_tuple* tuple) {tuple_ = tuple; tuple->asocTimer = this;}
    ~OLSRPO_DupTupleTimer();
    virtual void expire() override;
};

/// Timer for removing link tuples: OLSRPO_link_tuple.
class OLSRPO_LinkTupleTimer : public OLSRPO_Timer
{
  public:
    OLSRPO_LinkTupleTimer(OLSRPO* agent, OLSRPO_link_tuple* tuple);

    void setTuple(OLSRPO_link_tuple* tuple) {tuple_ = tuple; tuple->asocTimer = this;}
    ~OLSRPO_LinkTupleTimer();
    virtual void expire() override;
  protected:
    //OLSRPO_link_tuple*  tuple_; ///< OLSRPO_link_tuple which must be removed.
    bool            first_time_;

};


/// Timer for removing nb2hop tuples: OLSRPO_nb2hop_tuple.

class OLSRPO_Nb2hopTupleTimer : public OLSRPO_Timer
{
  public:
    OLSRPO_Nb2hopTupleTimer(OLSRPO* agent, OLSRPO_nb2hop_tuple* tuple) : OLSRPO_Timer(agent)
    {
        tuple_ = tuple;
    }

    void setTuple(OLSRPO_nb2hop_tuple* tuple) {tuple_ = tuple; tuple->asocTimer = this;}
    ~OLSRPO_Nb2hopTupleTimer();
    virtual void expire() override;
//  protected:
//  OLSRPO_nb2hop_tuple*  tuple_; ///< OLSRPO_link_tuple which must be removed.

};




/// Timer for removing MPR selector tuples: OLSRPO_mprsel_tuple.
class OLSRPO_MprSelTupleTimer : public OLSRPO_Timer
{
  public:
    OLSRPO_MprSelTupleTimer(OLSRPO* agent, OLSRPO_mprsel_tuple* tuple) : OLSRPO_Timer(agent)
    {
        tuple_ = tuple;
    }

    void setTuple(OLSRPO_mprsel_tuple* tuple) {tuple_ = tuple; tuple->asocTimer = this;}
    ~OLSRPO_MprSelTupleTimer();
    virtual void expire() override;

//  protected:
//  OLSRPO_mprsel_tuple*  tuple_; ///< OLSRPO_link_tuple which must be removed.

};


/// Timer for removing topology tuples: OLSRPO_topology_tuple.

class OLSRPO_TopologyTupleTimer : public OLSRPO_Timer
{
  public:
    OLSRPO_TopologyTupleTimer(OLSRPO* agent, OLSRPO_topology_tuple* tuple) : OLSRPO_Timer(agent)
    {
        tuple_ = tuple;
    }

    void setTuple(OLSRPO_topology_tuple* tuple) {tuple_ = tuple; tuple->asocTimer = this;}
    ~OLSRPO_TopologyTupleTimer();
    virtual void expire() override;
//  protected:
//  OLSRPO_topology_tuple*    tuple_; ///< OLSRPO_link_tuple which must be removed.

};

/// Timer for removing interface association tuples: OLSRPO_iface_assoc_tuple.
class OLSRPO_IfaceAssocTupleTimer : public OLSRPO_Timer
{
  public:
    OLSRPO_IfaceAssocTupleTimer(OLSRPO* agent, OLSRPO_iface_assoc_tuple* tuple) : OLSRPO_Timer(agent)
    {
        tuple_ = tuple;
    }

    void setTuple(OLSRPO_iface_assoc_tuple* tuple) {tuple_ = tuple; tuple->asocTimer = this;}
    ~OLSRPO_IfaceAssocTupleTimer();
    virtual void expire() override;
//  protected:
//  OLSRPO_iface_assoc_tuple* tuple_; ///< OLSRPO_link_tuple which must be removed.

};

/********** OLSRPO Agent **********/


///
/// \brief Routing agent which implements %OLSRPO protocol following RFC 3626.
///
/// Interacts with TCL interface through command() method. It implements all
/// functionalities related to sending and receiving packets and managing
/// internal state.
///

typedef std::set<OLSRPO_Timer *> TimerPendingList;
typedef std::multimap <simtime_t, OLSRPO_Timer *> TimerQueue;


class OLSRPO : public ManetRoutingBase
{
  protected:
    /********** Intervals **********/
    ///
    /// \brief Period at which a node must cite every link and every neighbor.
    ///
    /// We only use this value in order to define OLSRPO_NEIGHB_HOLD_TIME.
    ///
    double OLSRPO_REFRESH_INTERVAL;//   2

    double jitter() {return uniform(0,(double)OLSRPO_MAXJITTER);}
#define JITTER jitter()

  private:
    friend class OLSRPO_HelloTimer;
    friend class OLSRPO_TcTimer;
    friend class OLSRPO_MidTimer;
    friend class OLSRPO_DupTupleTimer;
    friend class OLSRPO_LinkTupleTimer;
    friend class OLSRPO_Nb2hopTupleTimer;
    friend class OLSRPO_MprSelTupleTimer;
    friend class OLSRPO_TopologyTupleTimer;
    friend class OLSRPO_IfaceAssocTupleTimer;
    friend class OLSRPO_MsgTimer;
    friend class OLSRPO_Timer;
  protected:

    //std::priority_queue<TimerQueueElem> *timerQueuePtr;
    bool topologyChange = false;
    virtual void setTopologyChanged(bool p) {topologyChange = p;}
    virtual bool getTopologyChanged() {return topologyChange;}
    TimerQueue *timerQueuePtr = nullptr;

    cMessage *timerMessage = nullptr;

// must be protected and used for dereved class OLSRPO_ETX
    /// A list of pending messages which are buffered awaiting for being sent.
    std::vector<OLSRPO_msg>   msgs_;
    /// Routing table.
    OLSRPO_rtable     rtable_;

    typedef std::map<nsaddr_t,OLSRPO_rtable*> GlobalRtable;
    static GlobalRtable globalRtable;
    typedef std::map<nsaddr_t,std::vector<nsaddr_t> > DistributionPath;
    static DistributionPath distributionPath;
    bool computed = false;
    /// Internal state with all needed data structs.

    OLSRPO_state      *state_ptr = nullptr;

    /// Packets sequence number counter.
    uint16_t    pkt_seq_ = OLSRPO_MAX_SEQ_NUM;
    /// Messages sequence number counter.
    uint16_t    msg_seq_ = OLSRPO_MAX_SEQ_NUM;
    /// Advertised Neighbor Set sequence number.
    uint16_t    ansn_ = OLSRPO_MAX_SEQ_NUM;

    /// HELLO messages' emission interval.
    cPar     *hello_ival_ = nullptr;
    /// TC messages' emission interval.
    cPar     *tc_ival_ = nullptr;
    /// MID messages' emission interval.
    cPar     *mid_ival_ = nullptr;
    /// Willingness for forwarding packets on behalf of other nodes.
    cPar     *willingness_ = nullptr;
    /// Determines if layer 2 notifications are enabled or not.
    int  use_mac_ = false;
    bool useIndex = false;

    bool optimizedMid = false;

  protected:
// Omnet INET vaiables and functions
    char nodeName[50];


    virtual OLSRPO_pkt * check_packet(cPacket*, nsaddr_t &, int &);

    // PortClassifier*  dmux_;      ///< For passing packets up to agents.
    // Trace*       logtarget_; ///< For logging.

    OLSRPO_HelloTimer *helloTimer = nullptr;    ///< Timer for sending HELLO messages.
    OLSRPO_TcTimer    *tcTimer = nullptr;   ///< Timer for sending TC messages.
    OLSRPO_MidTimer   *midTimer = nullptr;  ///< Timer for sending MID messages.

#define hello_timer_  (*helloTimer)
#define  tc_timer_  (*tcTimer)
#define mid_timer_  (*midTimer)

    /// Increments packet sequence number and returns the new value.
    inline uint16_t pkt_seq()
    {
        pkt_seq_ = (pkt_seq_ + 1)%(OLSRPO_MAX_SEQ_NUM + 1);
        return pkt_seq_;
    }
    /// Increments message sequence number and returns the new value.
    inline uint16_t msg_seq()
    {
        msg_seq_ = (msg_seq_ + 1)%(OLSRPO_MAX_SEQ_NUM + 1);
        return msg_seq_;
    }

    inline nsaddr_t    ra_addr()   { return getAddress();}

    inline double     hello_ival()    { return hello_ival_->doubleValue();}
    inline double     tc_ival()   { return tc_ival_->doubleValue();}
    inline double     mid_ival()  { return mid_ival_->doubleValue();}
    inline int     willingness()   { return willingness_->longValue();}
    inline int     use_mac()   { return use_mac_;}

    inline linkset_t&   linkset()   { return state_ptr->linkset(); }
    inline mprset_t&    mprset()    { return state_ptr->mprset(); }
    inline mprselset_t& mprselset() { return state_ptr->mprselset(); }
    inline nbset_t&     nbset()     { return state_ptr->nbset(); }
    inline nb2hopset_t& nb2hopset() { return state_ptr->nb2hopset(); }
    inline topologyset_t&   topologyset()   { return state_ptr->topologyset(); }
    inline dupset_t&    dupset()    { return state_ptr->dupset(); }
    inline ifaceassocset_t& ifaceassocset() { return state_ptr->ifaceassocset(); }

    virtual void        recv_olsr(cMessage*);

    virtual void        CoverTwoHopNeighbors(const nsaddr_t &neighborMainAddr, nb2hopset_t & N2);
    virtual void        mpr_computation();
    virtual void        rtable_computation();

    virtual bool        process_hello(OLSRPO_msg&, const nsaddr_t &, const nsaddr_t &, const int &);
    virtual bool        process_tc(OLSRPO_msg&, const nsaddr_t &, const int &);
    virtual void        process_mid(OLSRPO_msg&, const nsaddr_t &, const int &);

    virtual void        forward_default(OLSRPO_msg&, OLSRPO_dup_tuple*, const nsaddr_t &, const nsaddr_t &);
    virtual void        forward_data(cMessage* p) {}

    virtual void        enque_msg(OLSRPO_msg&, double);
    virtual void        send_hello();
    virtual void        send_tc();
    virtual void        send_mid();
    virtual void        send_pkt();

    virtual bool        link_sensing(OLSRPO_msg&, const nsaddr_t &, const nsaddr_t &, const int &);
    virtual bool        populate_nbset(OLSRPO_msg&);
    virtual bool        populate_nb2hopset(OLSRPO_msg&);
    virtual void        populate_mprselset(OLSRPO_msg&);

    virtual void        set_hello_timer();
    virtual void        set_tc_timer();
    virtual void        set_mid_timer();

    virtual void        nb_loss(OLSRPO_link_tuple*);
    virtual void        add_dup_tuple(OLSRPO_dup_tuple*);
    virtual void        rm_dup_tuple(OLSRPO_dup_tuple*);
    virtual void        add_link_tuple(OLSRPO_link_tuple*, uint8_t);
    virtual void        rm_link_tuple(OLSRPO_link_tuple*);
    virtual void        updated_link_tuple(OLSRPO_link_tuple*, uint8_t willingness);
    virtual void        add_nb_tuple(OLSRPO_nb_tuple*);
    virtual void        rm_nb_tuple(OLSRPO_nb_tuple*);
    virtual void        add_nb2hop_tuple(OLSRPO_nb2hop_tuple*);
    virtual void        rm_nb2hop_tuple(OLSRPO_nb2hop_tuple*);
    virtual void        add_mprsel_tuple(OLSRPO_mprsel_tuple*);
    virtual void        rm_mprsel_tuple(OLSRPO_mprsel_tuple*);
    virtual void        add_topology_tuple(OLSRPO_topology_tuple*);
    virtual void        rm_topology_tuple(OLSRPO_topology_tuple*);
    virtual void        add_ifaceassoc_tuple(OLSRPO_iface_assoc_tuple*);
    virtual void        rm_ifaceassoc_tuple(OLSRPO_iface_assoc_tuple*);
    virtual OLSRPO_nb_tuple*    find_or_add_nb(OLSRPO_link_tuple*, uint8_t willingness);

    const nsaddr_t  & get_main_addr(const nsaddr_t&) const;
    virtual int     degree(OLSRPO_nb_tuple*);

    static bool seq_num_bigger_than(uint16_t, uint16_t);
    virtual int numInitStages() const override { return NUM_INIT_STAGES; }
    virtual void initialize(int stage) override;
    virtual void    mac_failed(IPv4Datagram*);
    virtual void    recv(cMessage *p) {}

    virtual void handleMessage(cMessage *msg) override;
    virtual void finish() override;
    //virtual void processPromiscuous(const cObject *details){};
    virtual void processLinkBreak(const cObject *details) override;
    virtual void scheduleNextEvent();

    L3Address getIfaceAddressFromIndex(int index);

    const char * getNodeId(const nsaddr_t &addr);

    void computeDistributionPath(const nsaddr_t &initNode);

  public:
    OLSRPO() {}
    virtual ~OLSRPO();


    static double       emf_to_seconds(uint8_t);
    static uint8_t      seconds_to_emf(double);
    static int      node_id(const nsaddr_t&);

    // Routing information access
    virtual bool supportGetRoute() override {return true;}
    virtual uint32_t getRoute(const L3Address &, std::vector<L3Address> &) override;
    virtual bool getNextHop(const L3Address &, L3Address &add, int &iface, double &) override;
    virtual bool isProactive() override;
    virtual void setRefreshRoute(const L3Address &destination, const L3Address & nextHop,bool isReverse) override {}
    virtual bool isOurType(cPacket *) override;
    virtual bool getDestAddress(cPacket *, L3Address &) override;
    virtual int getRouteGroup(const AddressGroup &gr, std::vector<L3Address>&) override;
    virtual bool getNextHopGroup(const AddressGroup &gr, L3Address &add, int &iface, L3Address&) override;
    virtual int  getRouteGroup(const L3Address&, std::vector<L3Address> &, L3Address&, bool &, int group = 0) override;
    virtual bool getNextHopGroup(const L3Address&, L3Address &add, int &iface, L3Address&, bool &, int group = 0) override;

    //
    virtual void getDistributionPath(const L3Address&, std::vector<L3Address> &path);

    virtual bool isNodeCandidate(const L3Address&);

    virtual bool handleNodeStart(IDoneCallback *doneCallback) override;
    virtual bool handleNodeShutdown(IDoneCallback *doneCallback) override;
    virtual void handleNodeCrash() override;

};

} // namespace inetmanet

} // namespace inet

#endif
