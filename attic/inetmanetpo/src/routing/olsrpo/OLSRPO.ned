// Bachelorthesis 2017 - energybased OLSR routing, 2nd try
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com, TU Dortmund 2017
// NED routing module, derived from OLSR.ned, version 0.2

package inetmanetpo.routing.olsrpo;

import inet.networklayer.contract.IManetRouting;
import inet.routing.extras.base.BaseRouting;
import inet.power.contract.IEnergyStorage;

simple OLSRPO extends BaseRouting like IManetRouting
{
    parameters:
        // start modification
        // parameters for power optimization   
        // sensitivity must be in 0.1 ... 10
        double powerSensitivityMin = 0.1;
        double powerSensitivityMax = 10.0;
        double powerSensitivityDefault = 0.25;
        double powerSensitivity = default(powerSensitivityDefault);
        // power bias must be greater 0
        double powerBiasMin = 0.0;
        double powerBiasDefault = 0.0;
        double powerBias = default(powerBiasDefault);
        // power trigger, how much must the penalty rise for sending RERR in 0.05 .. 0.5
        double powerTriggerMin = 0.05;
        double powerTriggerMax = 0.5;
        double powerTriggerDefault = 0.2;
        double powerTrigger = default(powerTriggerDefault);
        // end modification
        
        @class(OLSRPO);
        string interfaceTableModule;
        string routingTableModule;
        string icmpModule = default("^.networkLayer.icmp");
        string arpModule = default("^.networkLayer.arp");
        int Willingness = default(3); // (0..7) The node's willingness to carry traffic on behalf of other nodes. 0:NEVER .. 7:ALWAYS (section 18.8)
        double Hello_ival @unit(s) = default(2s); // (s) HELLO messages' emission interval. (section 6.2)
        double Tc_ival @unit(s) = default(5s); // (s) Topology Control (TC) messages' emission interval. (section 9.3)
        double Mid_ival @unit(s) = default(5s); // (s) MID (multiple interface declaration) messages' emission interval. (section 5.2) (has effect only if compiled with multiple interface support)
        int use_mac = default(0); // Determines if layer 2 notifications are enabled or not (chapter 13)
        bool UseIndex = default(false); // use the interface index instead the ip to identify the interface (EXPERIMENTAL)
        bool reduceFuncionality = default(false);

        double OLSR_REFRESH_INTERVAL @unit("s") = default(2s);
        bool PublicRoutingTables = default(false);

        bool optimizedMid = default(false);// only nodes with more that a interface sends mid messages
        bool DelOnlyRtEntriesInrtable_ = default(false); // delete only ip entries that are in the interal routing table

    gates:
        input ipIn;
        output ipOut;
}



