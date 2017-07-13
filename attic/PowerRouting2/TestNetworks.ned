// Bachelorthesis 2017 - energybased routing, 2nd try
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com, TU Dortmund 2017
// networks for simulation, version 0.2

package PowerRouting2;

import inet.common.lifecycle.LifecycleController;
import inet.common.scenario.ScenarioManager;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.networklayer.ipv4.RoutingTableRecorder;
import inet.node.aodv.AODVRouter;
import inet.node.aodvpo.AODVPORouter;
import inet.node.olsr.OLSRRouter;
import inet.node.olsrpo.OLSRPORouter;
import inet.physicallayer.idealradio.IdealRadioMedium;
import inet.visualizer.contract.IIntegratedVisualizer;

network CoreNetworkAODV
{
    parameters:
        @display("bgb=1050,850");
    submodules:
        radioMedium: IdealRadioMedium {
            parameters:
                @display("p=900,75");
        }
        visualizer: <default("IntegratedCanvasVisualizer")> like IIntegratedVisualizer if hasVisualizer() {
            parameters:
            	@display("p=900,200");
        }
        configurator: IPv4NetworkConfigurator {
            parameters:
                addDefaultRoutes = false;
                addStaticRoutes = false;
                addSubnetRoutes = false;
                config = xml("<config><interface hosts='*' address='145.236.x.x' netmask='255.255.0.0'/></config>");
                @display("p=900,325");
        }
        routingTableRecorder: RoutingTableRecorder {
            parameters:
                @display("p=900,450");
        }
        lifecycleController: LifecycleController {
            parameters:
                @display("p=900,575");
        }
        scenarioManager: ScenarioManager {
            parameters:
                script = default(xml("<scenario/>"));
                @display("p=900,700");
        }
        
        router11: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,100");
        }
        
        router21: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,100");
        }
        
        router41: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,100");
        }
        
        router51: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,100");
        }
        
        
        router12: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,250");
        }
        
        router22: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,250");
        }
        
        router32: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,250");
        }
        
        router52: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,250");
        }
        
        router23: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,400");
        }
        
        router33: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,400");
        }
        
        router14: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,550");
        }
        
        router24: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,550");
        }
        
        router34: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,550");
        }
        
        router54: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,550");
        }
        
        
        router15: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,700");
        }
        
        router25: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,700");
        }
        
        router45: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,700");
        }
        
        router55: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,700");
        }
    connections allowunconnected:
}

network CoreNetworkAODVPO
{
    parameters:
        @display("bgb=1050,850");
    submodules:
        radioMedium: IdealRadioMedium {
            parameters:
                @display("p=900,75");
        }
        visualizer: <default("IntegratedCanvasVisualizer")> like IIntegratedVisualizer if hasVisualizer() {
            parameters:
            	@display("p=900,200");
        }
        configurator: IPv4NetworkConfigurator {
            parameters:
                addDefaultRoutes = false;
                addStaticRoutes = false;
                addSubnetRoutes = false;
                config = xml("<config><interface hosts='*' address='145.236.x.x' netmask='255.255.0.0'/></config>");
                @display("p=900,325");
        }
        routingTableRecorder: RoutingTableRecorder {
            parameters:
                @display("p=900,450");
        }
        lifecycleController: LifecycleController {
            parameters:
                @display("p=900,575");
        }
        scenarioManager: ScenarioManager {
            parameters:
                script = default(xml("<scenario/>"));
                @display("p=900,700");
        }
        
        router11: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,100");
        }
        
        router21: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,100");
        }
        
        router41: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,100");
        }
        
        router51: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,100");
        }
        
        
        router12: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,250");
        }
        
        router22: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,250");
        }
        
        router32: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,250");
        }
        
        router52: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,250");
        }
        
        router23: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,400");
        }
        
        router33: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,400");
        }
        
        router14: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,550");
        }
        
        router24: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,550");
        }
        
        router34: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,550");
        }
        
        router54: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,550");
        }
        
        
        router15: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,700");
        }
        
        router25: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,700");
        }
        
        router45: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,700");
        }
        
        router55: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,700");
        }
    connections allowunconnected:
}

network CoreNetworkAODVPOMixed
{
    parameters:
        @display("bgb=1050,850");
    submodules:
        radioMedium: IdealRadioMedium {
            parameters:
                @display("p=900,75");
        }
        visualizer: <default("IntegratedCanvasVisualizer")> like IIntegratedVisualizer if hasVisualizer() {
            parameters:
            	@display("p=900,200");
        }
        configurator: IPv4NetworkConfigurator {
            parameters:
                addDefaultRoutes = false;
                addStaticRoutes = false;
                addSubnetRoutes = false;
                config = xml("<config><interface hosts='*' address='145.236.x.x' netmask='255.255.0.0'/></config>");
                @display("p=900,325");
        }
        routingTableRecorder: RoutingTableRecorder {
            parameters:
                @display("p=900,450");
        }
        lifecycleController: LifecycleController {
            parameters:
                @display("p=900,575");
        }
        scenarioManager: ScenarioManager {
            parameters:
                script = default(xml("<scenario/>"));
                @display("p=900,700");
        }
        
        router11: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,100");
        }
        
        router21: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,100");
        }
        
        router41: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,100");
        }
        
        router51: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,100");
        }
        
        
        router12: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,250");
        }
        
        router22: AODVRouter {
            parameters:
                @display("p=250,250");
        }
        
        router32: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: AODVRouter {
            parameters:
                @display("p=550,250");
        }
        
        router52: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,250");
        }
        
        router23: AODVRouter {
            parameters:
                @display("p=250,400");
        }
        
        router33: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: AODVRouter {
            parameters:
                @display("p=550,400");
        }
        
        router14: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,550");
        }
        
        router24: AODVRouter {
            parameters:
                @display("p=250,550");
        }
        
        router34: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: AODVRouter {
            parameters:
                @display("p=550,550");
        }
        
        router54: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,550");
        }
        
        
        router15: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,700");
        }
        
        router25: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,700");
        }
        
        router45: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,700");
        }
        
        router55: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,700");
        }
    connections allowunconnected:
}

network TestNetworkAODV1S1R extends CoreNetworkAODV
{
    submodules:
        sender1: AODVRouter {
            parameters:
                @display("p=100,400");
        }
        receiver1: AODVRouter {
            parameters:
                @display("p=700,400");
        }     
        router31: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network TestNetworkAODVPO1S1R extends CoreNetworkAODVPO
{
    submodules:
        sender1: AODVPORouter {
            parameters:
                @display("p=100,400");
        }
        receiver1: AODVPORouter {
            parameters:
                @display("p=700,400");
        }     
        router31: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network TestNetworkAODV2S2R extends CoreNetworkAODV
{
    submodules:
        sender1: AODVRouter {
            parameters:
                @display("p=100,400");
        }
        receiver1: AODVRouter {
            parameters:
                @display("p=700,400");
        }
        sender2: AODVRouter {
            parameters:
                @display("p=400,100");
        }
        receiver2: AODVRouter {
            parameters:
                @display("p=400,700");
        }
    connections allowunconnected:
}

network TestNetworkAODVPO2S2R extends CoreNetworkAODVPO
{
    submodules:
        sender1: AODVPORouter {
            parameters:
                @display("p=100,400");
        }
        receiver1: AODVPORouter {
            parameters:
                @display("p=700,400");
        }
        sender2: AODVPORouter {
            parameters:
                @display("p=400,100");
        }
        receiver2: AODVPORouter {
            parameters:
                @display("p=400,700");
        }
    connections allowunconnected:
}

network TestNetworkAODVPO1S1RMixed extends CoreNetworkAODVPOMixed
{
    submodules:
        sender1: AODVPORouter {
            parameters:
                @display("p=100,400");
        }
        receiver1: AODVPORouter {
            parameters:
                @display("p=700,400");
        }
        router31: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network TestNetworkAODVPO2S2RMixed extends CoreNetworkAODVPOMixed
{
    submodules:
        sender1: AODVPORouter {
            parameters:
                @display("p=100,400");
        }
        receiver1: AODVPORouter {
            parameters:
                @display("p=700,400");
        }
        sender2: AODVPORouter {
            parameters:
                @display("p=400,100");
        }
        receiver2: AODVPORouter {
            parameters:
                @display("p=400,700");
        }
    connections allowunconnected:
}

network CoreNetworkOLSR
{
    parameters:
        @display("bgb=1050,850");
    submodules:
        radioMedium: IdealRadioMedium {
            parameters:
                @display("p=900,75");
        }
        visualizer: <default("IntegratedCanvasVisualizer")> like IIntegratedVisualizer if hasVisualizer() {
            parameters:
            	@display("p=900,200");
        }
        configurator: IPv4NetworkConfigurator {
            parameters:
                addDefaultRoutes = false;
                addStaticRoutes = false;
                addSubnetRoutes = false;
                config = xml("<config><interface hosts='*' address='145.236.x.x' netmask='255.255.0.0'/></config>");
                @display("p=900,325");
        }
        routingTableRecorder: RoutingTableRecorder {
            parameters:
                @display("p=900,450");
        }
        lifecycleController: LifecycleController {
            parameters:
                @display("p=900,575");
        }
        scenarioManager: ScenarioManager {
            parameters:
                script = default(xml("<scenario/>"));
                @display("p=900,700");
        }
        
        router11: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,100");
        }
        
        router21: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,100");
        }
        
        router41: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,100");
        }
        
        router51: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,100");
        }
        
        
        router12: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,250");
        }
        
        router22: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,250");
        }
        
        router32: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,250");
        }
        
        router52: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,250");
        }
        
        router23: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,400");
        }
        
        router33: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,400");
        }
        
        router14: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,550");
        }
        
        router24: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,550");
        }
        
        router34: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,550");
        }
        
        router54: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,550");
        }
        
        
        router15: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,700");
        }
        
        router25: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,700");
        }
        
        router45: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,700");
        }
        
        router55: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,700");
        }
    connections allowunconnected:
}

network CoreNetworkOLSRPO
{
    parameters:
        @display("bgb=1050,850");
    submodules:
        radioMedium: IdealRadioMedium {
            parameters:
                @display("p=900,75");
        }
        visualizer: <default("IntegratedCanvasVisualizer")> like IIntegratedVisualizer if hasVisualizer() {
            parameters:
            	@display("p=900,200");
        }
        configurator: IPv4NetworkConfigurator {
            parameters:
                addDefaultRoutes = false;
                addStaticRoutes = false;
                addSubnetRoutes = false;
                config = xml("<config><interface hosts='*' address='145.236.x.x' netmask='255.255.0.0'/></config>");
                @display("p=900,325");
        }
        routingTableRecorder: RoutingTableRecorder {
            parameters:
                @display("p=900,450");
        }
        lifecycleController: LifecycleController {
            parameters:
                @display("p=900,575");
        }
        scenarioManager: ScenarioManager {
            parameters:
                script = default(xml("<scenario/>"));
                @display("p=900,700");
        }
        
        router11: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,100");
        }
        
        router21: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,100");
        }
        
        router41: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,100");
        }
        
        router51: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,100");
        }
        
        
        router12: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,250");
        }
        
        router22: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,250");
        }
        
        router32: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,250");
        }
        
        router52: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,250");
        }
        
        router23: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,400");
        }
        
        router33: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,400");
        }
        
        router14: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,550");
        }
        
        router24: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,550");
        }
        
        router34: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,550");
        }
        
        router54: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,550");
        }
        
        
        router15: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,700");
        }
        
        router25: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,700");
        }
        
        router45: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,700");
        }
        
        router55: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,700");
        }
    connections allowunconnected:
}

network CoreNetworkOLSRPOMixed
{
    parameters:
        @display("bgb=1050,850");
    submodules:
        radioMedium: IdealRadioMedium {
            parameters:
                @display("p=900,75");
        }
        visualizer: <default("IntegratedCanvasVisualizer")> like IIntegratedVisualizer if hasVisualizer() {
            parameters:
            	@display("p=900,200");
        }
        configurator: IPv4NetworkConfigurator {
            parameters:
                addDefaultRoutes = false;
                addStaticRoutes = false;
                addSubnetRoutes = false;
                config = xml("<config><interface hosts='*' address='145.236.x.x' netmask='255.255.0.0'/></config>");
                @display("p=900,325");
        }
        routingTableRecorder: RoutingTableRecorder {
            parameters:
                @display("p=900,450");
        }
        lifecycleController: LifecycleController {
            parameters:
                @display("p=900,575");
        }
        scenarioManager: ScenarioManager {
            parameters:
                script = default(xml("<scenario/>"));
                @display("p=900,700");
        }
        
        router11: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,100");
        }
        
        router21: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,100");
        }
        
        router41: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,100");
        }
        
        router51: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,100");
        }
        
        
        router12: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,250");
        }
        
        router22: OLSRRouter {
            parameters:
                @display("p=250,250");
        }
        
        router32: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: OLSRRouter {
            parameters:
                @display("p=550,250");
        }
        
        router52: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,250");
        }
        
        router23: OLSRRouter {
            parameters:
                @display("p=250,400");
        }
        
        router33: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: OLSRRouter {
            parameters:
                @display("p=550,400");
        }
        
        router14: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,550");
        }
        
        router24: OLSRRouter {
            parameters:
                @display("p=250,550");
        }
        
        router34: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: OLSRRouter {
            parameters:
                @display("p=550,550");
        }
        
        router54: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,550");
        }
        
        
        router15: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,700");
        }
        
        router25: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,700");
        }
        
        router45: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,700");
        }
        
        router55: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,700");
        }
    connections allowunconnected:
}

network TestNetworkOLSR1S1R extends CoreNetworkOLSR
{
    submodules:
        sender1: OLSRRouter {
            parameters:
                @display("p=100,400");
        }
        receiver1: OLSRRouter {
            parameters:
                @display("p=700,400");
        }     
        router31: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network TestNetworkOLSRPO1S1R extends CoreNetworkOLSRPO
{
    submodules:
        sender1: OLSRPORouter {
            parameters:
                @display("p=100,400");
        }
        receiver1: OLSRPORouter {
            parameters:
                @display("p=700,400");
        }     
        router31: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network TestNetworkOLSR2S2R extends CoreNetworkOLSR
{
    submodules:
        sender1: OLSRRouter {
            parameters:
                @display("p=100,400");
        }
        receiver1: OLSRRouter {
            parameters:
                @display("p=700,400");
        }
        sender2: OLSRRouter {
            parameters:
                @display("p=400,100");
        }
        receiver2: OLSRRouter {
            parameters:
                @display("p=400,700");
        }
    connections allowunconnected:
}

network TestNetworkOLSRPO2S2R extends CoreNetworkOLSRPO
{
    submodules:
        sender1: OLSRPORouter {
            parameters:
                @display("p=100,400");
        }
        receiver1: OLSRPORouter {
            parameters:
                @display("p=700,400");
        }
        sender2: OLSRPORouter {
            parameters:
                @display("p=400,100");
        }
        receiver2: OLSRPORouter {
            parameters:
                @display("p=400,700");
        }
    connections allowunconnected:
}

network TestNetworkOLSRPO1S1RMixed extends CoreNetworkOLSRPOMixed
{
    submodules:
        sender1: OLSRPORouter {
            parameters:
                @display("p=100,400");
        }
        receiver1: OLSRPORouter {
            parameters:
                @display("p=700,400");
        }
        router31: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network TestNetworkOLSRPO2S2RMixed extends CoreNetworkOLSRPOMixed
{
    submodules:
        sender1: OLSRPORouter {
            parameters:
                @display("p=100,400");
        }
        receiver1: OLSRPORouter {
            parameters:
                @display("p=700,400");
        }
        sender2: OLSRPORouter {
            parameters:
                @display("p=400,100");
        }
        receiver2: OLSRPORouter {
            parameters:
                @display("p=400,700");
        }
    connections allowunconnected:
}
