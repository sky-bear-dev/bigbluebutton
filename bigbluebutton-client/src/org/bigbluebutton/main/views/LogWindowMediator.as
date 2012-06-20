package org.bigbluebutton.main.views
{
    import org.bigbluebutton.core.model.imp.LoggerModel;
    import org.robotlegs.mvcs.Mediator;
    
    public class LogWindowMediator extends Mediator
    {
        [Inject]
        public var view:LogWindow;
        
        [Inject]
        public var model:LoggerModel;
        
        override public function onRegister():void
        {
            view.logs = model;
            view.displayLogMessages();
            // addViewListener();
            // addContextListener();
        }
    }
}