package org.bigbluebutton.core
{
    import flash.display.DisplayObjectContainer;
    
    import org.bigbluebutton.core.commands.StartupCompleteCommand;
    import org.bigbluebutton.core.model.ILocaleModel;
    import org.bigbluebutton.core.model.imp.LocaleModel;
    import org.bigbluebutton.core.model.imp.LogModel;
    import org.bigbluebutton.core.services.i18n.ILocaleService;
    import org.bigbluebutton.core.services.i18n.LocaleLoaderService;
    import org.robotlegs.base.ContextEvent;
    import org.robotlegs.mvcs.Context;
    
    public class BigBlueButtonContext extends Context
    {
        public function BigBlueButtonContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
        {
            super(contextView, autoStartup);
        }
        
        override public function startup():void {
            injector.mapSingletonOf(Logger, LogModel);
            
 //           injector.mapSingletonOf(ILocaleService, LocaleLoaderService);
 //           injector.mapSingletonOf(ILocale, LocaleModel);
 //           injector.mapSingletonOf(ILocaleModel, LocaleModel);
            
            commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupCompleteCommand, ContextEvent);
            
            dispatchEvent(new ContextEvent(ContextEvent.STARTUP_COMPLETE));
                
        }
    }
}