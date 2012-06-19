package org.bigbluebutton.core.controllers.commands.locale
{
    import org.bigbluebutton.core.model.imp.LocaleModel;
    import org.bigbluebutton.core.services.imp.LocaleLoaderService;
    import org.robotlegs.mvcs.Command;
    
    public class LoadMasterLocaleCommand extends Command
    {
        [Inject]
        public var localeModel: LocaleModel;
        
        [Inject]
        public var service: LocaleLoaderService;
        
        override public function execute():void
        {
            service.loadLocaleResource(localeModel.masterLocale);
        }
    }
}