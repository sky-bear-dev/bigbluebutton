package org.bigbluebutton.main.views
{
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.core.model.imp.LoggerModel;
    import org.robotlegs.mvcs.Mediator;
    
    public class LogWindowMediator extends Mediator
    {
        [Inject]
        public var view:LogWindow;
        
        [Inject]
        public var logger:Logger;
        
        override public function onRegister():void
        {
            view.logger = logger;
            view.displayLogMessages();
            // addViewListener();
            // addContextListener();
        }
    }
}