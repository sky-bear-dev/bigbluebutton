package org.bigbluebutton.modules.present.views
{
    import org.bigbluebutton.core.Logger;
    import org.robotlegs.mvcs.Mediator;
    
    public class PresentationWindowMediator extends Mediator
    {
        [Inject]
        public var view:PresentationWindow;
    
        [Inject] 
        public var logger:Logger;
        
        override public function onRegister():void
        {  
            logger.debug("PresentationWindowMediator onRegister");
        }
    }
}