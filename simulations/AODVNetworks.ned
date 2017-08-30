// PowerRouting for OMNeT++ - AODV network definition
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details

package powerrouting.simulations;

import inet.common.lifecycle.LifecycleController;
import inet.common.scenario.ScenarioManager;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.networklayer.ipv4.RoutingTableRecorder;
import powerrouting.node.aodv.AODVRouter;
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

//        router22: AODVRouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=250,250");
//        }
        
        router32: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
//        router42: AODVRouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=550,250");
//        }
        
//        router23: AODVRouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=250,400");
//        }
        
        router33: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
//        router43: AODVRouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=550,400");
//        }
        
//		router24: AODVRouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=250,550");
//        }
        
        router34: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
//        router44: AODVRouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=550,550");
//        }
        
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
        
//        router22: AODVPORouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=250,250");
//        }
        
        router32: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
//        router42: AODVPORouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=550,250");
//        }
        
//        router23: AODVPORouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=250,400");
//        }
        
        router33: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
//        router43: AODVPORouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=550,400");
//        }
        
//        router24: AODVPORouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=250,550");
//        }
        
        router34: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
//        router44: AODVPORouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=550,550");
//        }
        
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
        
    connections allowunconnected:
}

network AODV extends AODVCoreNetwork
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

network AODVPO extends AODVPOCoreNetwork
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

network AODVPOMixed extends AODVPOCoreNetworkMixed
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

network AODVPOCompare extends AODVPOCoreNetwork
{
    submodules:
        router13: AODVPORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        router53: AODVPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,400");
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

network AODVCompare extends AODVCoreNetwork
{
    submodules:
        router13: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,400");
        }
        router53: AODVRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,400");
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