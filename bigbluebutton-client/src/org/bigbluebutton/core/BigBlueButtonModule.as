package org.bigbluebutton.core
{
    import flash.display.DisplayObjectContainer;
    import flash.system.ApplicationDomain;
    
    import mx.modules.Module;
    
    import org.robotlegs.core.IInjector;
    import org.robotlegs.utilities.modular.core.IModule;
    import org.robotlegs.utilities.modular.mvcs.ModuleContext;
    
    public class BigBlueButtonModule extends Module
    {
        protected var context:ModuleContext;
        protected var contextView:DisplayObjectContainer;
        protected var injector:IInjector;
        		        
        public function start(contextView:DisplayObjectContainer, value:IInjector):void {
            throw new Error("You need to override the start method.");
        }
             
        public function dispose():void {
            throw new Error("You need to override the dispose method.");
        }

        public function foo():String {
            throw new Error("You need to override the foo method.");
        }
    }
}