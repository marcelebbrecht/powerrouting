// PowerRouting for OMNeT++ - Batman network definition
// Marcel Ebbrecht, marcel.ebbrecht@googlemail.com
// free software, see LICENSE.md for details

package powerrouting.simulations;

import inet.common.lifecycle.LifecycleController;
import inet.common.scenario.ScenarioManager;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.networklayer.ipv4.RoutingTableRecorder;
import powerrouting.node.batman.BatmanRouter;
import powerrouting.node.batmanpo.BatmanPORouter;
import inet.physicallayer.idealradio.IdealRadioMedium;
import inet.visualizer.contract.IIntegratedVisualizer;

network BatmanCoreNetwork
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
        
        router11: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,100");
        }
        
        router21: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,100");
        }
        
        router41: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,100");
        }
        
        router51: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,100");
        }
        
        
        router12: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,250");
        }
        
        router22: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,250");
        }
        
        router32: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,250");
        }
        
        router52: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,250");
        }
        
        router23: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,400");
        }
        
        router33: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,400");
        }
        
        router14: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,550");
        }
        
        router24: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,550");
        }
        
        router34: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,550");
        }
        
        router54: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,550");
        }
        
        
        router15: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,700");
        }
        
        router25: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,700");
        }
        
        router45: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,700");
        }
        
        router55: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,700");
        }
    connections allowunconnected:
}

network BatmanPOCoreNetwork
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
        
        router11: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,100");
        }
        
        router21: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,100");
        }
        
        router41: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,100");
        }
        
        router51: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,100");
        }
        
        
        router12: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,250");
        }
        
        router22: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,250");
        }
        
        router32: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,250");
        }
        
        router52: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,250");
        }
        
        router23: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,400");
        }
        
        router33: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,400");
        }
        
        router14: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,550");
        }
        
        router24: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,550");
        }
        
        router34: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,550");
        }
        
        router54: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,550");
        }
        
        
        router15: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,700");
        }
        
        router25: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,700");
        }
        
        router45: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,700");
        }
        
        router55: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,700");
        }
    connections allowunconnected:
}

network BatmanPOCoreNetworkMixed
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
        
        router11: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,100");
        }
        
        router21: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,100");
        }
        
        router41: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,100");
        }
        
        router51: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,100");
        }
        
        
        router12: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,250");
        }
        
        router22: BatmanRouter {
            parameters:
                @display("i=device/accesspoint;p=250,250");
        }
        
        router32: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,250");
        }
        
        router42: BatmanRouter {
            parameters:
                @display("i=device/accesspoint;p=550,250");
        }
        
        router52: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,250");
        }
        
        router23: BatmanRouter {
            parameters:
                @display("i=device/accesspoint;p=250,400");
        }
        
        router33: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,400");
        }
        
        router43: BatmanRouter {
            parameters:
                @display("i=device/accesspoint;p=550,400");
        }
        
        router14: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,550");
        }
        
        router24: BatmanRouter {
            parameters:
                @display("i=device/accesspoint;p=250,550");
        }
        
        router34: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,550");
        }
        
        router44: BatmanRouter {
            parameters:
                @display("i=device/accesspoint;p=550,550");
        }
        
        router54: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,550");
        }
        
        
        router15: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=100,700");
        }
        
        router25: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=250,700");
        }
        
        router45: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=550,700");
        }
        
        router55: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,700");
        }
    connections allowunconnected:
}

network Batman extends BatmanCoreNetwork
{
    submodules:
        sender1: BatmanRouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: BatmanRouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
        }     
        router31: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network BatmanPO extends BatmanPOCoreNetwork
{
    submodules:
        sender1: BatmanPORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: BatmanPORouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
        }     
        router31: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network BatmanPOMixed extends BatmanPOCoreNetworkMixed
{
    submodules:
        sender1: BatmanPORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: BatmanPORouter {
            parameters:
                @display("i=device/accesspoint;p=700,400");
        }
        router31: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network BatmanPOCompare extends BatmanPOCoreNetwork
{
    submodules:
        sender1: BatmanPORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,400");
        }
        router31: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network BatmanPOCompareMulti extends BatmanPOCoreNetwork
{
    submodules:
        sender1: BatmanPORouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        router53: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,400");
        }
        router31: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: BatmanPORouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network BatmanCompare extends BatmanCoreNetwork
{
    submodules:
        sender1: BatmanRouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        receiver1: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,400");
        }
        router31: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}

network BatmanCompareMulti extends BatmanCoreNetwork
{
    submodules:
        sender1: BatmanRouter {
            parameters:
                @display("i=device/accesspoint;p=100,400");
        }
        router53: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=700,400");
        }
        router31: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,100");
        }
        router35: BatmanRouter {
            parameters:
                @display("i=device/pocketpc_s;r=,,#707070;p=400,700");
        }
    connections allowunconnected:
}
