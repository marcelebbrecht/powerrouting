// PowerRouting for OMNeT++ - OLSR network definition
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details

package powerrouting.simulations;

import inet.common.lifecycle.LifecycleController;
import inet.common.scenario.ScenarioManager;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.networklayer.ipv4.RoutingTableRecorder;
import powerrouting.node.olsrpo.OLSRPORouter;
import powerrouting.node.olsr.OLSRRouter;
import inet.physicallayer.idealradio.IdealRadioMedium;
import inet.visualizer.contract.IIntegratedVisualizer;

network OLSRCoreNetwork
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
        
//        router22: OLSRRouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=250,250");
//        }
        
        router32: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
//        router42: OLSRRouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=550,250");
//        }
        
//        router23: OLSRRouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=250,400");
//        }
        
        router33: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
//        router43: OLSRRouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=550,400");
//        }
        
//        router24: OLSRRouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=250,550");
//        }
        
        router34: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
//        router44: OLSRRouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=550,550");
//        }
    connections allowunconnected:
}

network OLSRPOCoreNetwork
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
        
//        router22: OLSRPORouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=250,250");
//        }
        
        router32: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
//        router42: OLSRPORouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=550,250");
//        }
        
//        router23: OLSRPORouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=250,400");
//        }
        
        router33: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
//        router43: OLSRPORouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=550,400");
//        }
        
//        router24: OLSRPORouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=250,550");
//        }
        
        router34: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
//        router44: OLSRPORouter {
//            parameters:
//                @display("i=device/accesspoint;r=,,#707070;p=550,550");
//        }
    connections allowunconnected:
}

network OLSRPOCoreNetworkMixed
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
        
        router22: OLSRRouter {
            parameters:
                @display("i=device/accesspoint;p=250,250");
        }
        
        router32: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: OLSRRouter {
            parameters:
                @display("i=device/accesspoint;p=550,250");
        }
        
        router23: OLSRRouter {
            parameters:
                @display("i=device/accesspoint;p=250,400");
        }
        
        router33: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: OLSRRouter {
            parameters:
                @display("i=device/accesspoint;p=550,400");
        }
        
        router24: OLSRRouter {
            parameters:
                @display("i=device/accesspoint;p=250,550");
        }
        
        router34: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: OLSRRouter {
            parameters:
                @display("i=device/accesspoint;p=550,550");
        }
    connections allowunconnected:
}

network OLSR extends OLSRCoreNetwork
{
    submodules:
        sender1: OLSRRouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: OLSRRouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
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

network OLSRPO extends OLSRPOCoreNetwork
{
    submodules:
        sender1: OLSRPORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: OLSRPORouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
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

network OLSRPOMixed extends OLSRPOCoreNetworkMixed
{
    submodules:
        sender1: OLSRPORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: OLSRPORouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
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

network OLSRMultiple
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
        
        router22: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;p=250,250");
        }
        
        router32: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;p=550,250");
        }
        
        router23: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;p=250,400");
        }
        
        router33: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;p=550,400");
        }
        
        router24: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;p=250,550");
        }
        
        router34: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;p=550,550");
        }
        
        sender1: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,400");
        }
        router53: OLSRRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,400");
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

network OLSRPOMultiple
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
        
        router22: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;p=250,250");
        }
        
        router32: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;p=550,250");
        }
        
        router23: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;p=250,400");
        }
        
        router33: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;p=550,400");
        }
        
        router24: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;p=250,550");
        }
        
        router34: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;p=550,550");
        }
        
        sender1: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,400");
        }
        router53: OLSRPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,400");
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
