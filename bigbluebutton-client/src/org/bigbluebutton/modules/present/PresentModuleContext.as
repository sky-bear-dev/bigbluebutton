package org.bigbluebutton.modules.present
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.system.ApplicationDomain;
    
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.modules.present.controller.commands.StartPresentationModuleCommand;
    import org.bigbluebutton.modules.present.controller.events.PresentationModuleContextStartedEvent;
    import org.bigbluebutton.modules.present.controller.events.PresentationModuleReadyEvent;
    import org.bigbluebutton.modules.present.views.PresentationModuleShell;
    import org.bigbluebutton.modules.present.views.PresentationModuleShellMediator;
    import org.bigbluebutton.modules.present.views.PresentationWindow;
    import org.bigbluebutton.modules.present.views.PresentationWindowMediator;
    import org.robotlegs.base.ContextEvent;
    import org.robotlegs.core.IInjector;
    import org.robotlegs.utilities.modular.mvcs.ModuleContext;
    
    public class PresentModuleContext extends ModuleContext
    {
        [Injector]
        public var logger:Logger;
        
        public function PresentModuleContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true, parentInjector:IInjector=null, applicationDomain:ApplicationDomain=null)
        {
            this.contextView = contextView;
            super(contextView, autoStartup, parentInjector, applicationDomain);
        }
        
        override public function startup():void {
         //   logger.debug("***Starting presentation module");
            mediatorMap.mapView(PresentationWindow, PresentationWindowMediator);
            mediatorMap.mapView(PresentationModuleShell, PresentationModuleShellMediator);
            addEventListener(PresentationModuleReadyEvent.PRESENTATION_MODULE_READY_EVENT, PresentationModuleReadyEventHandler);
            
            commandMap.mapEvent(PresentationModuleContextStartedEvent.PRESENTATION_MODULE_CONTEXT_STARTED_EVENT, StartPresentationModuleCommand);
        
            contextView.addChild(new PresentationModuleShell());
            
            dispatchEvent(new PresentationModuleContextStartedEvent());
        }
        
        protected function PresentationModuleReadyEventHandler(event:Event):void {
            logger.debug("Handling PresentationModuleReadyEventHandler");
        }
    }
}