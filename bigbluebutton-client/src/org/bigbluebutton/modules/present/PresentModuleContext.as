package org.bigbluebutton.modules.present
{
    import flash.display.DisplayObjectContainer;
    import flash.events.Event;
    import flash.system.ApplicationDomain;
    
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.core.model.imp.LoggerModel;
    import org.bigbluebutton.modules.present.controller.commands.StartPresentationModuleCommand;
    import org.bigbluebutton.modules.present.controller.events.PresentationModuleContextStartedEvent;
    import org.bigbluebutton.modules.present.controller.events.PresentationModuleReadyEvent;
    import org.bigbluebutton.modules.present.views.PresentationModuleShell;
    import org.bigbluebutton.modules.present.views.PresentationModuleShellMediator;
    import org.bigbluebutton.modules.present.views.PresentationWindow;
    import org.bigbluebutton.modules.present.views.PresentationWindowMediator;
    import org.robotlegs.base.ContextEvent;
    import org.robotlegs.core.IInjector;
    import org.robotlegs.mvcs.Context;

    
    public class PresentModuleContext extends Context
    {
        [Injector]
        public var logger:Logger;
        
        public function PresentModuleContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
        {
//            this.contextView = contextView;
            super(contextView, autoStartup);
        }
        
        override public function startup():void {
            logger.debug("*** Starting presentation module");
        //    injector.mapSingletonOf(Logger, LoggerModel);
            mediatorMap.mapView(PresentationWindow, PresentationWindowMediator);
            mediatorMap.mapView(PresentationModuleShell, PresentationModuleShellMediator);
            addEventListener(PresentationModuleReadyEvent.PRESENTATION_MODULE_READY_EVENT, PresentationModuleReadyEventHandler);
            
 //           commandMap.mapEvent(); 
            commandMap.mapEvent(PresentationModuleContextStartedEvent.PRESENTATION_MODULE_CONTEXT_STARTED_EVENT, StartPresentationModuleCommand);
  //          contextView.addChild(new PresentationModuleShell());
            dispatchEvent(new PresentationModuleContextStartedEvent());
      //      dispatchEvent();
        }
        
        protected function PresentationModuleReadyEventHandler(event:Event):void {
 //           logger.debug("Handling PresentationModuleReadyEventHandler");
        }
    }
}