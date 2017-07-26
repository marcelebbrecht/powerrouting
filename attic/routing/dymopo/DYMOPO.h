// PowerRouting for OMNeT++ - DYMOPO routing
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details
// derived from inetmanet-3.5, DYMO.h

#ifndef __DYMOPO_omnet_h__

#define __DYMOPO_omnet_h__
#include "../dymo/DYMO.h"
#include "inet/power/contract/IEnergyStorage.h"
#include "inet/power/storage/SimpleEpEnergyStorage.h"
#include "inet/power/contract/IEpEnergyStorage.h"

typedef inet::power::IEpEnergyStorage IEpEnergyStorage;

class DYMOPO : public DYMO
{
  protected:
    // parameters for energy-optimization
    cModule *host = nullptr;
    IEpEnergyStorage *energyStorage = nullptr;
    double relativeCharge = 0;
    double newWillingnessDouble = 0;
    int newWillingness = 0;
    double powerSensitivity = 0;
    double powerSensitivityMin = 0;
    double powerSensitivityMax = 0;
    double powerSensitivityDefault = 0;
    double powerBias = 0;
    double powerBiasMin = 0;
    double powerBiasDefault = 0;
    double powerTrigger = 0;
    double powerTriggerMin = 0;
    double powerTriggerMax = 0;
    double powerTriggerDefault = 0;
    double powerTriggerDouble = 0;
    int powerTriggerCalculated = 999999999;
    int powerTriggerLast = 999999999;
};

#endif

