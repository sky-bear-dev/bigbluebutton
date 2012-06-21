package org.bigbluebutton.main.views
{
    import org.bigbluebutton.core.controllers.events.config.ConfigLoadEvent;
    import org.bigbluebutton.core.model.imp.ConfigModel;
    import org.bigbluebutton.main.views.vo.LayoutOptions;
    import org.robotlegs.mvcs.Mediator;
    
    public class MainApplicationShellMediator extends Mediator
    {
        [Inject]
        public var view: MainApplicationShell;
        
        [Inject]
        public var config:ConfigModel;
        
        override public function onRegister():void
        {
//            addViewListener();
            addContextListener(ConfigLoadEvent.CONFIG_LOADED_EVENT, handleConfigLoadedEvent, ConfigLoadEvent);
            
 //           dispatch(new MainShellReadyEvent(MainShellReadyEvent.READY));
        }
        
        private function handleConfigLoadedEvent(e:ConfigLoadEvent):void {
            view.setLayout(new LayoutOptions(config.layout));
        }
    }
}