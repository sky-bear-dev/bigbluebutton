package org.bigbluebutton.main.views
{
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.core.controllers.events.UserAuthenticatedEvent;
    import org.bigbluebutton.core.controllers.events.module.AllModulesLoadedEvent;
    import org.bigbluebutton.core.controllers.events.module.ModuleLoadProgressEvent;
    import org.robotlegs.mvcs.Mediator;
    
    public class BigBlueButtonAppShellMediator extends Mediator
    {
        [Inject]
        public var view:BigBlueButtonAppShell;
        
        [Inject] 
        public var logger:Logger;
        
        override public function onRegister():void
        {   
            addViewListener(LogButtonClickedEvent.LOG_BUTTON_CLICKED_EVENT, handleLogButtonClieckedEvent);
            
            addContextListener(ModuleLoadProgressEvent.MODULE_LOAD_PROGRESS_EVENT, moduleLoadProgressEventHandler, ModuleLoadProgressEvent);
            addContextListener(UserAuthenticatedEvent.USER_AUTHENTICATED_EVENT, userAuthenticatedEventHandler, UserAuthenticatedEvent);
            addContextListener(AllModulesLoadedEvent.ALL_MODULES_LOADED_EVENT, allModulesLoadedEventHandler, AllModulesLoadedEvent);
            
        }
 
        protected function handleLogButtonClieckedEvent(e:LogButtonClickedEvent):void{
            view.appendProgress(logger.messages);
        }
        
        protected function allModulesLoadedEventHandler(e:AllModulesLoadedEvent):void{
            view.appendProgress("All modules have been loaded");
        }
        
        protected function moduleLoadProgressEventHandler(e:ModuleLoadProgressEvent):void{
            view.appendProgress("Module loading : " + e.moduleName + " loading " + e.percentLoaded);
        }
        
        protected function userAuthenticatedEventHandler(e:UserAuthenticatedEvent):void {
            view.appendProgress("User has authenticated");
            view.userHasBeenAuthenticated();
        }
    }
}