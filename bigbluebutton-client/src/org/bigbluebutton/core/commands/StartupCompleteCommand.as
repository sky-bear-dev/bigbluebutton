package org.bigbluebutton.core.commands
{
    import org.bigbluebutton.core.Logger;
    import org.robotlegs.mvcs.Command;
    
    public class StartupCompleteCommand extends Command
    {
        [Inject]
        public var logger:Logger;
        
        public function StartupCompleteCommand()
        {
            super();
        }
        
        override public function execute():void {
            logger.debug("Startup complete");
        }
    }
}