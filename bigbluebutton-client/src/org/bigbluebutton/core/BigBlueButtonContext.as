package org.bigbluebutton.core
{
    import flash.display.DisplayObjectContainer;
    
    import org.bigbluebutton.core.controllers.commands.StartupCompleteCommand;
    import org.bigbluebutton.core.controllers.commands.locale.LoadMasterLocaleCommand;
    import org.bigbluebutton.core.controllers.commands.locale.SwitchLocaleCommand;
    import org.bigbluebutton.core.controllers.events.locale.LocaleEvent;
    import org.bigbluebutton.core.controllers.events.locale.SwitchLocaleEvent;
    import org.bigbluebutton.core.model.imp.LocaleModel;
    import org.bigbluebutton.core.model.imp.LoggerModel;
    import org.bigbluebutton.core.services.ILocaleService;
    import org.bigbluebutton.core.services.imp.LocaleConfigLoaderService;
    import org.bigbluebutton.main.views.LoadingBar;
    import org.bigbluebutton.main.views.LoadingBarMediator;
    import org.bigbluebutton.main.views.MainApplicationShell;
    import org.bigbluebutton.main.views.MainApplicationShellMediator;
    import org.bigbluebutton.main.views.MainCanvas;
    import org.bigbluebutton.main.views.MainCanvasMediator;
    import org.bigbluebutton.main.views.MainToolbar;
    import org.bigbluebutton.main.views.MainToolbarMediator;
    import org.robotlegs.base.ContextEvent;
    import org.robotlegs.utilities.modular.mvcs.ModuleContext;
    
    public class BigBlueButtonContext extends ModuleContext
    {
        public function BigBlueButtonContext(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true)
        {
            super(contextView, autoStartup);
        }
        
        override public function startup():void {
            injector.mapSingletonOf(Logger, LoggerModel);
            
            injector.mapSingletonOf(ILocaleService, LocaleConfigLoaderService);
            injector.mapSingletonOf(LocaleModel, LocaleModel);
 //           injector.mapSingletonOf(ILocaleModel, LocaleModel);
            
            mediatorMap.mapView(MainApplicationShell, MainApplicationShellMediator);
            mediatorMap.mapView(MainCanvas, MainCanvasMediator);
            mediatorMap.mapView(LoadingBar, LoadingBarMediator);
            mediatorMap.mapView(MainToolbar, MainToolbarMediator);
            
            commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupCompleteCommand, ContextEvent);
            commandMap.mapEvent(LocaleEvent.LIST_OF_AVAILABLE_LOCALES_LOADED_EVENT, LoadMasterLocaleCommand);
            commandMap.mapEvent(SwitchLocaleEvent.SWITCH_TO_NEW_LOCALE_EVENT, SwitchLocaleCommand);
            
            dispatchEvent(new ContextEvent(ContextEvent.STARTUP_COMPLETE));
                
        }
    }
}