package org.bigbluebutton.modules.present
{
    import flash.display.DisplayObjectContainer;
    import flash.system.ApplicationDomain;
    
    import org.bigbluebutton.core.Logger;
    import org.robotlegs.core.IInjector;
    import org.robotlegs.utilities.modular.mvcs.ModuleContext;
    
    public class PresentModuleContext extends ModuleContext
    {
        [Injector]
        public var logger:Logger;
        
        public function PresentModuleContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true, parentInjector:IInjector=null, applicationDomain:ApplicationDomain=null)
        {
            super(contextView, autoStartup, parentInjector, applicationDomain);
        }
        
        override public function startup():void {
            logger.debug("Starting presentation module");    
        }
    }
}