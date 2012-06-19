package org.bigbluebutton.core.controllers.commands
{
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.core.services.imp.LocaleConfigLoaderService;
    import org.robotlegs.mvcs.Command;
    
    public class StartupBigBlueButtonCommand extends Command
    {
        [Inject]
        public var logger:Logger;
        
        [Inject]
        public var service:LocaleConfigLoaderService;
        
        override public function execute():void {
            logger.debug("Startup complete");
            service.determineAvailableLocales();
        }
    }
}