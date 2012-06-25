package org.bigbluebutton.core
{
    import flash.display.DisplayObjectContainer;
    import flash.display.Sprite;
    import flash.system.ApplicationDomain;
    
    import mx.core.UIComponent;
    import mx.modules.Module;
    
    import org.robotlegs.core.IInjector;
    import org.robotlegs.utilities.modular.core.IModule;
  
    
    public class ModuleWrapper extends UIComponent implements IModule
    {
        protected var injector:IInjector;
        
        public var bModule:BigBlueButtonModule;
        
		[Inject]
		public var logger:Logger;
		        
        public function start():void {
            logger.error("Starting module.");
            bModule.start(this, injector);
        }
        
		[Inject]
        public function set parentInjector(value:IInjector):void {
            logger.error("Injecting parent injector.");
            injector = value;
        }
        
        public function dispose():void {
			logger.error("You should override dispose");
            bModule.dispose();
        }
		
		public function foo():String {
			return "FOOBAR";
		}
		
    }
}