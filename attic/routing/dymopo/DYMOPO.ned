// PowerRouting for OMNeT++ - DYMOPO routing definition
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, DYMO.ned

package powerrouting.routing.dymopo;

import inet.networklayer.contract.IManetRouting;
import inet.routing.extras.base.BaseRouting;
import powerrouting.routing.dymo.DYMO;
import inet.power.contract.IEnergyStorage;

simple DYMOPO extends DYMO
{
    parameters:
        // start modification
        // parameters for power optimization   
        // sensitivity must be in 0.0 ... 0.999999
        double powerSensitivityMin = 0.0;
        double powerSensitivityMax = 0.9999999;
        double powerSensitivityDefault = 0.0;
        double powerSensitivity = default(powerSensitivityDefault);
        // power bias must be greater 0
        double powerBiasMin = 0.0;
        double powerBiasDefault = 0.0;
        double powerBias = default(powerBiasDefault);
        // power trigger, how much must the power be lower for sending routing error in 0.05 .. 0.5
        double powerTriggerMin = 0.05;
        double powerTriggerMax = 0.5;
        double powerTriggerDefault = 0.3;
        double powerTrigger = default(powerTriggerDefault);
        // end modification
        
        @class(DYMOPO);
}



