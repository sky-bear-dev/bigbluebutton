package org.bigbluebutton.modules.present.controller.commands
{
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.modules.present.controller.events.PresentationModuleReadyEvent;
    import org.robotlegs.mvcs.Command;
    import org.robotlegs.utilities.modular.mvcs.ModuleCommand;
    
    public class StartPresentationModuleCommand extends ModuleCommand
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