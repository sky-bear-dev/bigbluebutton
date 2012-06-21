package org.bigbluebutton.main.views
{
    import org.bigbluebutton.core.controllers.events.config.ConfigLoadEvent;
    import org.bigbluebutton.core.model.imp.ConfigModel;
    import org.bigbluebutton.main.views.vo.LayoutOptions;
    import org.robotlegs.mvcs.Mediator;
    
    public class MainToolbarMediator extends Mediator
    {
        [Inject]
        public var config:ConfigModel;
        
        [Inject]
        public var view:MainToolbar;
        
        override public function onRegister():void
        {
            //            addViewListener();
            addContextListener(ConfigLoadEvent.CONFIG_LOADED_EVENT, handleConfigLoadedEvent, ConfigLoadEvent);
        }
        
        protected function handleConfigLoadedEvent(e:ConfigLoadEvent):void {
            view.setLayout(new LayoutOptions(config.layout));            
        }        
    }
}