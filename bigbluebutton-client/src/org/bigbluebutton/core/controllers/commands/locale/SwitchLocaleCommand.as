package org.bigbluebutton.core.controllers.commands.locale
{
    import org.bigbluebutton.core.controllers.events.locale.SwitchLocaleEvent;
    import org.bigbluebutton.core.services.imp.LocaleLoaderService;
    import org.robotlegs.mvcs.Command;
    
    public class SwitchLocaleCommand extends Command
    {
        
        [Inject]
        public var event: SwitchLocaleEvent;
        
        [Inject]
        public var service: LocaleLoaderService;
        
        override public function execute():void
        {
            service.loadLocaleResource(event.newLocale);
        }
    }
}