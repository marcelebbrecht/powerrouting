// PowerRouting for OMNeT++ - AODV network definition
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details

package powerrouting.simulations;

import inet.common.lifecycle.LifecycleController;
import inet.common.scenario.ScenarioManager;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.networklayer.ipv4.RoutingTableRecorder;
import inet.node.aodv.AODVRouter;
import powerrouting.node.aodvpo.AODVPORouter;
import inet.physicallayer.idealradio.IdealRadioMedium;
import inet.visualizer.contract.IIntegratedVisualizer;

network AODVCoreNetwork
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

network AODVPOCoreNetwork
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

network AODVPOCoreNetworkMixed
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
                @display("i=device/accesspoint;p=250,250");
        }
        
        router32: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: AODVRouter {
            parameters:
                @display("i=device/accesspoint;p=550,250");
        }
        
        router52: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,250");
        }
        
        router23: AODVRouter {
            parameters:
                @display("i=device/accesspoint;p=250,400");
        }
        
        router33: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: AODVRouter {
            parameters:
                @display("i=device/accesspoint;p=550,400");
        }
        
        router14: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,550");
        }
        
        router24: AODVRouter {
            parameters:
                @display("i=device/accesspoint;p=250,550");
        }
        
        router34: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: AODVRouter {
            parameters:
                @display("i=device/accesspoint;p=550,550");
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

network AODV1S1R extends AODVCoreNetwork
{
    submodules:
        sender1: AODVRouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: AODVRouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
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

network AODVPO1S1R extends AODVPOCoreNetwork
{
    submodules:
        sender1: AODVPORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: AODVPORouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
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

network AODV2S2R extends AODVCoreNetwork
{
    submodules:
        sender1: AODVRouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: AODVRouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
        }
        sender2: AODVRouter {
            parameters:
                @display("i=device/accesspoint;p=400,100");
        }
        receiver2: AODVRouter {
            parameters:
                @display("i=device/accesspoint;p=400,700");
        }
    connections allowunconnected:
}

network AODVPO2S2R extends AODVPOCoreNetwork
{
    submodules:
        sender1: AODVPORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: AODVPORouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
        }
        sender2: AODVPORouter {
            parameters:
                @display("i=device/accesspoint;p=400,100");
        }
        receiver2: AODVPORouter {
            parameters:
                @display("i=device/accesspoint;p=400,700");
        }
    connections allowunconnected:
}

network AODVPO1S1RMixed extends AODVPOCoreNetworkMixed
{
    submodules:
        sender1: AODVPORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: AODVPORouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
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

network AODVPO2S2RMixed extends AODVPOCoreNetworkMixed
{
    submodules:
        sender1: AODVPORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: AODVPORouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
        }
        sender2: AODVPORouter {
            parameters:
                @display("i=device/accesspoint;p=400,100");
        }
        receiver2: AODVPORouter {
            parameters:
                @display("i=device/accesspoint;p=400,700");
        }
    connections allowunconnected:
}
