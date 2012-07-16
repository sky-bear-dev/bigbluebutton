package org.bigbluebutton.core.commands.i18n
{
    import org.bigbluebutton.core.model.ILocaleModel;
    import org.bigbluebutton.core.services.i18n.ILocaleService;
    import org.robotlegs.mvcs.Command;
    
    public class LocaleCommand extends Command
    {
        [Inject]
        public var localeModel: ILocaleModel;
        
        [Inject]
        public var localeService: ILocaleService;
        
        override public function execute()
        {
            localeService.loadMasterLocale();
        }
    }
}