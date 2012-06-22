package org.bigbluebutton.core
{
    import flash.display.DisplayObjectContainer;
    import flash.system.ApplicationDomain;    
    import mx.modules.Module;    
    import org.robotlegs.core.IInjector;
    import org.robotlegs.utilities.modular.core.IModule;
    import org.robotlegs.utilities.modular.core.IModuleContext;
    
    public class BigBlueButtonModule extends Module implements IModule
    {
        protected var context:IModuleContext;
        
        public function start():void {}
        
        public function set parentInjector(value:IInjector):void {
            
        }
        
        public function dispose():void {
            
        }
    }
}