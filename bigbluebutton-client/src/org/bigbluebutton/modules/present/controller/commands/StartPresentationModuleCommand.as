package org.bigbluebutton.modules.present.controller.commands
{
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.modules.present.controller.events.PresentationModuleReadyEvent;
    import org.robotlegs.mvcs.Command;
    
    public class StartPresentationModuleCommand extends Command
    {
        [Inject]
        public var logger:Logger;
        
        override public function execute():void
        {
            logger.debug("StartPresentationModuleCommand");
            dispatch(new PresentationModuleReadyEvent());
        }
    }
}