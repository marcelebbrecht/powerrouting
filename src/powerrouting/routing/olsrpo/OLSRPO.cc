// PowerRouting for OMNeT++ - OLSRPO routing
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details

#include "OLSRPO.h"

Define_Module(OLSRPO);

// start modification
// define signal for measure of routing overhead
simsignal_t OLSRPO::routingOverheadSignal = registerSignal("routingOverheadBytes");
// end modification

void OLSRPO::initialize(int stage)
{
    OLSR::initialize(stage);

    // get energy storage and assign power based routing parameters
    host = getContainingNode(this);
    energyStorage = dynamic_cast<IEpEnergyStorage *>(host->getSubmodule("energyStorage"));
    powerSensitivity = par("powerSensitivity");
    powerSensitivityMin = par("powerSensitivityMin");
    powerSensitivityMax = par("powerSensitivityMax");
    powerSensitivityDefault = par("powerSensitivityDefault");
    powerBias = par("powerBias");
    powerBiasMin = par("powerBiasMin");
    powerBiasDefault = par("powerBiasDefault");
    powerTrigger = par("powerTrigger");
    powerTriggerMin = par("powerTriggerMin");
    powerTriggerMax = par("powerTriggerMax");
    powerTriggerDefault = par("powerTriggerDefault");

    // checking and setting power routing values to default if out if bounds
    if ( powerSensitivity < powerSensitivityMin || powerSensitivity > powerSensitivityMax ) {
        EV_ERROR << "Power Routing - powerSensitivity out of bounds: " << powerSensitivity << ", setting default value: " << powerSensitivityDefault << endl;
        powerSensitivity = powerSensitivityDefault;
    }
    EV_INFO << "Power Routing - powerSensitivity: " << powerSensitivity << endl;

    if ( powerBias < powerBiasMin ) {
        EV_ERROR << "Power Routing - powerBias out of bounds: " << powerBias << ", setting default value: " << powerBiasDefault << endl;
        powerBias = powerBiasDefault;
    }
    EV_INFO << "Power Routing - powerBias: " << powerBias << endl;

    if ( powerTrigger < powerTriggerMin || powerTrigger > powerTriggerMax ) {
        EV_ERROR << "Power Routing - powerTrigger out of bounds: " << powerTrigger << ", setting default value: " << powerTriggerDefault << endl;
        powerTrigger = powerTriggerDefault;
    }
    EV_INFO << "Power Routing - powerTrigger: " << powerTrigger << endl;
}

int OLSRPO::calculateWillingness(int willingness) {
    if ( strcmp(host->getSubmodule("energyStorage")->getClassName(), "inet::power::SimpleEpEnergyStorage") ) {
        EV_INFO << "Power Routing - StorageType is not SimpleEpEnergyStorage(" << host->getSubmodule("energyStorage")->getClassName() << ") returning one (normal behavior)" << endl;
        return willingness;
    } else {
        EV_INFO << "Power Routing - StorageType is SimpleEpEnergyStorage, calculating willingness according to energy-capacity" << endl;
        relativeCharge = energyStorage->getResidualEnergyCapacity().get() / energyStorage->getNominalEnergyCapacity().get();
//        newWillingnessDouble = ((1 / (relativeCharge / powerSensitivity))) + powerBias;
        newWillingnessDouble = ( 7 * relativeCharge * ( 1 - powerSensitivity ) ) - powerBias;
        if ( newWillingnessDouble < 1 ) {
            newWillingnessDouble = 1;
        }
        newWillingness = (int)(newWillingnessDouble);
        EV_INFO << "Power Routing - Capacities: " << energyStorage->getResidualEnergyCapacity() << " (actual) of " << energyStorage->getNominalEnergyCapacity() << " (nominal) " << endl;
        EV_INFO << "Power Routing - Relative charge: " << relativeCharge << " percent" << endl;
        EV_INFO << "Power Routing - New willingness double: " << newWillingnessDouble << endl;
        EV_INFO << "Power Routing - New willingness rounded: " << newWillingness << endl;
        return newWillingness;
    }
}

// function for calculating trigger
int OLSRPO::calculateTrigger() {
    if ( strcmp(host->getSubmodule("energyStorage")->getClassName(), "inet::power::SimpleEpEnergyStorage") ) {
        EV_INFO << "Power Routing - StorageType is not SimpleEpEnergyStorage(" << host->getSubmodule("energyStorage")->getClassName() << ") returning one (normal behavior)" << endl;
        return 1;
    } else {
        EV_INFO << "Power Routing - StorageType is SimpleEpEnergyStorage, calculating trigger according to energy-capacity" << endl;
        relativeCharge = energyStorage->getResidualEnergyCapacity().get() / energyStorage->getNominalEnergyCapacity().get();
        powerTriggerDouble = ( 1 - relativeCharge ) / powerTrigger;
        powerTriggerCalculated = (int)(powerTriggerDouble);
        EV_INFO << "Power Routing - Capacities: " << energyStorage->getResidualEnergyCapacity() << " (actual) of " << energyStorage->getNominalEnergyCapacity() << " (nominal) " << endl;
        EV_INFO << "Power Routing - Relative charge: " << relativeCharge << " percent" << endl;
        EV_INFO << "Power Routing - Power Trigger Setting: " << powerTrigger << endl;
        EV_INFO << "Power Routing - Power Trigger Calculated Double: " << powerTriggerDouble << endl;
        EV_INFO << "Power Routing - Power Trigger Calculated: " << powerTriggerCalculated << endl;
        return powerTriggerCalculated;
    }
}

// processing hello
bool OLSRPO::process_hello(OLSR_msg& msg, const nsaddr_t &receiver_iface, const nsaddr_t &sender_iface, const int &index) {
    if ( ! strcmp(host->getSubmodule("energyStorage")->getClassName(), "inet::power::SimpleEpEnergyStorage") ) {
        int calculatedWillingness = this->calculateWillingness(this->willingness());
        int newTrigger = this->calculateTrigger();

        EV_INFO << "Power Routing - Processing hello packet - " << host->getName() << " - actual willingness: " << this->willingness() <<
                ", new willingness: " << calculatedWillingness << ", power: " << energyStorage->getResidualEnergyCapacity().get() <<
                ", old trigger: " << powerTriggerLast << ", new trigger: " << newTrigger << endl;

        // check if capacity changed significantly and set new willingness
        EV_INFO << "Power Routing - Trigger, old: " << powerTriggerLast << ", act: " << newTrigger << endl;
        if ( powerTriggerLast < newTrigger ) {
          EV_INFO << "Power Routing - Capacity changed significantly, setting new willingness" << endl;
          setWillingness(calculatedWillingness);
        }
        EV_INFO << "Power Routing - Updating power trigger, old: " << powerTriggerLast << ", new: " << newTrigger << endl;
        powerTriggerLast = newTrigger;
    }

    return OLSR::process_hello(msg, receiver_iface, sender_iface, index);
}

// setter for willingness
void OLSRPO::setWillingness(int willingnessValue) {
    //willingness_->setStringValue(std::to_string(willingnessValue));
    willingness_->setDoubleValue(willingnessValue);
}
