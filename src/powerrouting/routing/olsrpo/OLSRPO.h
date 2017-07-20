// PowerRouting for OMNeT++ - OLSRPO routing
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details

#ifndef __OLSRPO_omnet_h__

#define __OLSRPO_omnet_h__
#include "../olsr/OLSR.h"
#include "inet/power/contract/IEnergyStorage.h"
#include "inet/power/storage/SimpleEpEnergyStorage.h"
#include "inet/power/contract/IEpEnergyStorage.h"

typedef inet::power::IEpEnergyStorage IEpEnergyStorage;

class OLSRPO : public OLSR
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

  protected:
    // override initialization, RREP creation and forwarding
    void initialize(int stage) override;
    virtual bool process_hello(OLSR_msg&, const nsaddr_t &, const nsaddr_t &, const int &) override;

    // calculate the penalty and trigger and set willingness
    int calculateWillingness(int willingness);
    int calculateTrigger();
    void setWillingness(int willingnessValue);
};

#endif

