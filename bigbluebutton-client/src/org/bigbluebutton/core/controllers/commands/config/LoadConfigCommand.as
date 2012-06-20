package org.bigbluebutton.core.controllers.commands.config
{
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.core.services.imp.ConfigLoaderService;
    import org.robotlegs.mvcs.Command;
    
    public class LoadConfigCommand extends Command
    {
        [Inject]
        public var service:ConfigLoaderService;
        
        [Inject]
        public var logger:Logger;
        
        override public function execute():void
        {
            logger.debug("Loading config");
            service.loadConfig();
        }
    }
}