// PowerRouting for OMNeT++ - DYMO network definition
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details

package powerrouting.simulations;

import inet.common.lifecycle.LifecycleController;
import inet.common.scenario.ScenarioManager;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.networklayer.ipv4.RoutingTableRecorder;
import inet.node.dymo.DYMORouter;
import powerrouting.node.dymopo.DYMOPORouter;
import inet.physicallayer.idealradio.IdealRadioMedium;
import inet.visualizer.contract.IIntegratedVisualizer;
import inet.linklayer.ieee80211.IIeee80211Mac;
import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;

network DYMOCoreNetwork
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
//        scenarioManager: ScenarioManager {
//            parameters:
//                script = default(xml("<scenario/>"));
//                @display("p=900,700");
//        }
        
        router11: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,100");
        }
        
        router21: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,100");
        }
        
        router41: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,100");
        }
        
        router51: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,100");
        }
        
        
        router12: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,250");
        }
        
        router22: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,250");
        }
        
        router32: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,250");
        }
        
        router52: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,250");
        }
        
        router23: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,400");
        }
        
        router33: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,400");
        }
        
        router14: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,550");
        }
        
        router24: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,550");
        }
        
        router34: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,550");
        }
        
        router54: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,550");
        }
        
        
        router15: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,700");
        }
        
        router25: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,700");
        }
        
        router45: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,700");
        }
        
        router55: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,700");
        }
    connections allowunconnected:
}

network DYMOPOCoreNetwork
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
        
        router11: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,100");
        }
        
        router21: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,100");
        }
        
        router41: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,100");
        }
        
        router51: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,100");
        }
        
        
        router12: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,250");
        }
        
        router22: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,250");
        }
        
        router32: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,250");
        }
        
        router52: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,250");
        }
        
        router23: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,400");
        }
        
        router33: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,400");
        }
        
        router14: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,550");
        }
        
        router24: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,550");
        }
        
        router34: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,550");
        }
        
        router54: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,550");
        }
        
        
        router15: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,700");
        }
        
        router25: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,700");
        }
        
        router45: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,700");
        }
        
        router55: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,700");
        }
    connections allowunconnected:
}

network DYMOPOCoreNetworkMixed
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
        
        router11: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,100");
        }
        
        router21: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,100");
        }
        
        router41: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,100");
        }
        
        router51: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,100");
        }
        
        
        router12: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,250");
        }
        
        router22: DYMORouter {
            parameters:
                @display("i=device/accesspoint;p=250,250");
        }
        
        router32: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: DYMORouter {
            parameters:
                @display("i=device/accesspoint;p=550,250");
        }
        
        router52: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,250");
        }
        
        router23: DYMORouter {
            parameters:
                @display("i=device/accesspoint;p=250,400");
        }
        
        router33: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: DYMORouter {
            parameters:
                @display("i=device/accesspoint;p=550,400");
        }
        
        router14: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,550");
        }
        
        router24: DYMORouter {
            parameters:
                @display("i=device/accesspoint;p=250,550");
        }
        
        router34: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: DYMORouter {
            parameters:
                @display("i=device/accesspoint;p=550,550");
        }
        
        router54: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,550");
        }
        
        
        router15: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,700");
        }
        
        router25: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,700");
        }
        
        router45: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,700");
        }
        
        router55: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,700");
        }
    connections allowunconnected:
}

network DYMO extends DYMOCoreNetwork
{
    submodules:
        sender1: DYMORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: DYMORouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
        }     
        router31: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: DYMORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network DYMOPO extends DYMOPOCoreNetwork
{
    submodules:
        sender1: DYMOPORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: DYMOPORouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
        }     
        router31: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network DYMOPOMixed extends DYMOPOCoreNetworkMixed
{
    submodules:
        sender1: DYMOPORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: DYMOPORouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
        }
        router31: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: DYMOPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}
