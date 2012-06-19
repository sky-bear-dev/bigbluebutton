package org.bigbluebutton.core.controllers.commands.locale
{
    import org.bigbluebutton.core.controllers.events.locale.LocaleEvent;
    import org.bigbluebutton.core.model.imp.LocaleModel;
    import org.bigbluebutton.core.services.imp.LocaleLoaderService;
    import org.robotlegs.mvcs.Command;
    
    public class LoadDefaultLocaleCommand extends Command
    {
        [Inject]
        public var model:LocaleModel;
        
        [Inject]
        public var service:LocaleLoaderService;
        
        override public function execute():void
        {
            var defaultLocale:String = model.defaultLocale;
            if (defaultLocale != null  && defaultLocale != "" && defaultLocale != model.masterLocale) {
                service.loadLocaleResource(defaultLocale);                    
            } else {
                var event:LocaleEvent = new LocaleEvent(LocaleEvent.PREFERRED_LOCALE_LOADED_EVENT);
                event.loadedLocale = model.masterLocale;
                dispatch(event);
            }
        }
    }
}