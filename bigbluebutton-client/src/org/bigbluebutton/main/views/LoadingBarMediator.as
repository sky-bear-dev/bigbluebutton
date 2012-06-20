package org.bigbluebutton.main.views
{
    
    import mx.controls.Alert;
    
    import org.bigbluebutton.core.controllers.events.module.ModuleLoadProgressEvent;
    import org.robotlegs.mvcs.Mediator;
    
    public class LoadingBarMediator extends Mediator
    {
        [Inject]
        public var view:LoadingBar;
        
        override public function onRegister():void
        {
            
            addContextListener(ModuleLoadProgressEvent.MODULE_LOAD_PROGRESS_EVENT, moduleLoadProgressEventHandler, ModuleLoadProgressEvent);
            
            //           dispatch(new MainShellReadyEvent(MainShellReadyEvent.READY));
        }
        
        protected function moduleLoadProgressEventHandler(e:ModuleLoadProgressEvent):void{
            Alert.show("Loading " + e.percentLoaded);
            view.setProgress(e.percentLoaded, 100);
        }
    }
}