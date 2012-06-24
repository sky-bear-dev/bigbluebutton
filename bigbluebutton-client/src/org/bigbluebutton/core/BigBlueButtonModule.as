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
        
		[Inject]
		public var logger:Logger;
		
        public function start():void {}
        
		[Inject]
        public function set parentInjector(value:IInjector):void {
            logger.error("***You should override parentInjector");
        }
        
        public function dispose():void {
			logger.error("You should override dispose");
        }
		
		public function foo():String {
			return "FOOBAR";
		}
		
    }
}