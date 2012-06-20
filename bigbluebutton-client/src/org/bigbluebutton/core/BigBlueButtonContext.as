package org.bigbluebutton.core
{
    import flash.display.DisplayObjectContainer;
    
    import org.bigbluebutton.core.controllers.commands.StartupBigBlueButtonCommand;
    import org.bigbluebutton.core.controllers.commands.config.LoadConfigCommand;
    import org.bigbluebutton.core.controllers.commands.locale.CompareLocaleVersionCommand;
    import org.bigbluebutton.core.controllers.commands.locale.LoadDefaultLocaleCommand;
    import org.bigbluebutton.core.controllers.commands.locale.LoadMasterLocaleCommand;
    import org.bigbluebutton.core.controllers.commands.locale.SwitchLocaleCommand;
    import org.bigbluebutton.core.controllers.commands.module.LoadAllModuleCommand;
    import org.bigbluebutton.core.controllers.events.config.ConfigLoadEvent;
    import org.bigbluebutton.core.controllers.events.config.ConfigVersionEvent;
    import org.bigbluebutton.core.controllers.events.locale.LocaleEvent;
    import org.bigbluebutton.core.controllers.events.locale.SwitchLocaleEvent;
    import org.bigbluebutton.core.controllers.events.module.ModuleLoadedEvent;
    import org.bigbluebutton.core.model.imp.ConfigModel;
    import org.bigbluebutton.core.model.imp.LocaleModel;
    import org.bigbluebutton.core.model.imp.LoggerModel;
    import org.bigbluebutton.core.model.imp.ModuleModel;
    import org.bigbluebutton.core.services.ILocaleService;
    import org.bigbluebutton.core.services.imp.ConfigLoaderService;
    import org.bigbluebutton.core.services.imp.ConfigToModuleDataParser;
    import org.bigbluebutton.core.services.imp.LocaleConfigLoaderService;
    import org.bigbluebutton.core.services.imp.LocaleLoaderService;
    import org.bigbluebutton.core.services.imp.ModuleDependencyResolver;
    import org.bigbluebutton.core.services.imp.ModuleLoaderService;
    import org.bigbluebutton.main.views.LoadingBar;
    import org.bigbluebutton.main.views.LoadingBarMediator;
    import org.bigbluebutton.main.views.LogWindow;
    import org.bigbluebutton.main.views.LogWindowMediator;
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
            
            injector.mapSingleton(LocaleLoaderService);
            injector.mapSingleton(LocaleConfigLoaderService);
            injector.mapSingleton(LocaleModel);
            injector.mapSingleton(ConfigModel);
			injector.mapSingleton(ModuleModel);
            injector.mapSingleton(ConfigLoaderService);
			injector.mapSingleton(ConfigToModuleDataParser);
            injector.mapSingleton(ModuleDependencyResolver);
            injector.mapSingleton(ModuleLoaderService);
            
            mediatorMap.mapView(MainApplicationShell, MainApplicationShellMediator);
            mediatorMap.mapView(MainCanvas, MainCanvasMediator);
            mediatorMap.mapView(LoadingBar, LoadingBarMediator);
            mediatorMap.mapView(MainToolbar, MainToolbarMediator);
            mediatorMap.mapView(LogWindow, LogWindowMediator);
            
            commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupBigBlueButtonCommand, ContextEvent);
            commandMap.mapEvent(LocaleEvent.LIST_OF_AVAILABLE_LOCALES_LOADED_EVENT, LoadMasterLocaleCommand);
            commandMap.mapEvent(LocaleEvent.MASTER_LOCALE_LOADED_EVENT, LoadDefaultLocaleCommand);
            commandMap.mapEvent(LocaleEvent.PREFERRED_LOCALE_LOADED_EVENT, LoadConfigCommand);
			commandMap.mapEvent(ConfigLoadEvent.CONFIG_LOADED_EVENT, CompareLocaleVersionCommand);
            commandMap.mapEvent(ConfigVersionEvent.CONFIG_VERSION_SAME_EVENT, LoadAllModuleCommand);
            commandMap.mapEvent(ModuleLoadedEvent.MODULE_LOADED_EVENT, LoadAllModuleCommand);
            commandMap.mapEvent(SwitchLocaleEvent.SWITCH_TO_NEW_LOCALE_EVENT, SwitchLocaleCommand);
            
            dispatchEvent(new ContextEvent(ContextEvent.STARTUP_COMPLETE));
                
        }
    }
}