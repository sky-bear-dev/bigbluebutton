package org.bigbluebutton.core.controllers.commands.module
{
    import org.bigbluebutton.core.Logger;
    import org.robotlegs.mvcs.Command;
    
    public class StartAllModulesCommand extends Command
    {
        [Inject]
        public var logger:Logger;
        
        override public function execute():void
        {
            logger.debug("Starting all modules");
        }
    }
}