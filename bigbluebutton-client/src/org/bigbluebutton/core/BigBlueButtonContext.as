package org.bigbluebutton.core
{
    import flash.display.DisplayObjectContainer;
    
    import org.bigbluebutton.core.controllers.commands.ConnectToRed5BBBCommand;
    import org.bigbluebutton.core.controllers.commands.GetAllUsersCommand;
    import org.bigbluebutton.core.controllers.commands.GetMyUserIdCommand;
    import org.bigbluebutton.core.controllers.commands.JoinUserCommand;
    import org.bigbluebutton.core.controllers.commands.ListenForUserMessagesCommand;
    import org.bigbluebutton.core.controllers.commands.StartupBigBlueButtonCommand;
    import org.bigbluebutton.core.controllers.commands.config.LoadConfigCommand;
    import org.bigbluebutton.core.controllers.commands.locale.CompareLocaleVersionCommand;
    import org.bigbluebutton.core.controllers.commands.locale.LoadDefaultLocaleCommand;
    import org.bigbluebutton.core.controllers.commands.locale.LoadMasterLocaleCommand;
    import org.bigbluebutton.core.controllers.commands.locale.SwitchLocaleCommand;
    import org.bigbluebutton.core.controllers.commands.module.LoadAllModuleCommand;
    import org.bigbluebutton.core.controllers.commands.module.StartAllModulesCommand;
    import org.bigbluebutton.core.controllers.events.ConnectedToRed5Event;
    import org.bigbluebutton.core.controllers.events.GotAllUsersEvent;
    import org.bigbluebutton.core.controllers.events.ListeningForUserMessagesEvent;
    import org.bigbluebutton.core.controllers.events.UserAuthenticatedEvent;
    import org.bigbluebutton.core.controllers.events.UsersConnectionEvent;
    import org.bigbluebutton.core.controllers.events.config.ConfigLoadEvent;
    import org.bigbluebutton.core.controllers.events.config.ConfigVersionEvent;
    import org.bigbluebutton.core.controllers.events.locale.LocaleEvent;
    import org.bigbluebutton.core.controllers.events.locale.SwitchLocaleEvent;
    import org.bigbluebutton.core.controllers.events.module.AllModulesLoadedEvent;
    import org.bigbluebutton.core.controllers.events.module.ModuleLoadedEvent;
    import org.bigbluebutton.core.model.imp.ConfigModel;
    import org.bigbluebutton.core.model.imp.LocaleModel;
    import org.bigbluebutton.core.model.imp.LoggerModel;
    import org.bigbluebutton.core.model.imp.MeetingModel;
    import org.bigbluebutton.core.model.imp.ModuleModel;
    import org.bigbluebutton.core.model.imp.UsersModel;
    import org.bigbluebutton.core.services.ILocaleService;
    import org.bigbluebutton.core.services.imp.ConfigLoaderService;
    import org.bigbluebutton.core.services.imp.ConfigToModuleDataParser;
    import org.bigbluebutton.core.services.imp.JoinService;
    import org.bigbluebutton.core.services.imp.JoinServiceXmlParser;
    import org.bigbluebutton.core.services.imp.LocaleConfigLoaderService;
    import org.bigbluebutton.core.services.imp.LocaleLoaderService;
    import org.bigbluebutton.core.services.imp.ModuleDependencyResolver;
    import org.bigbluebutton.core.services.imp.ModuleLoaderService;
    import org.bigbluebutton.core.services.imp.Red5BBBAppConnectionService;
    import org.bigbluebutton.core.services.imp.UsersService;
    import org.bigbluebutton.main.views.BigBlueButtonAppShell;
    import org.bigbluebutton.main.views.BigBlueButtonAppShellMediator;
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
            
            injector.mapClass(ModuleLoaderService, ModuleLoaderService);
			injector.mapClass(ModuleWrapper, ModuleWrapper);
			
            injector.mapSingleton(LocaleLoaderService);
            injector.mapSingleton(LocaleConfigLoaderService);
            injector.mapSingleton(LocaleModel);
            injector.mapSingleton(ConfigModel);
			injector.mapSingleton(ModuleModel);
            injector.mapSingleton(UsersModel);
            injector.mapSingleton(ConfigLoaderService);
			injector.mapSingleton(ConfigToModuleDataParser);
            injector.mapSingleton(ModuleDependencyResolver);
            injector.mapSingleton(JoinService);
            injector.mapSingleton(JoinServiceXmlParser);
            injector.mapSingleton(Red5BBBAppConnectionService);
            injector.mapSingleton(MeetingModel);
            injector.mapSingleton(UsersService);
            
			viewMap.mapType(ModuleWrapper);
            viewMap.mapType(BigBlueButtonModule);
            
            mediatorMap.mapView(MainApplicationShell, MainApplicationShellMediator);
            mediatorMap.mapView(MainCanvas, MainCanvasMediator);
            mediatorMap.mapView(LoadingBar, LoadingBarMediator);
            mediatorMap.mapView(MainToolbar, MainToolbarMediator);
            mediatorMap.mapView(LogWindow, LogWindowMediator);
            mediatorMap.mapView(BigBlueButtonAppShell, BigBlueButtonAppShellMediator);
            
            commandMap.mapEvent(ContextEvent.STARTUP_COMPLETE, StartupBigBlueButtonCommand, ContextEvent);
            commandMap.mapEvent(LocaleEvent.LIST_OF_AVAILABLE_LOCALES_LOADED_EVENT, LoadMasterLocaleCommand);
            commandMap.mapEvent(LocaleEvent.MASTER_LOCALE_LOADED_EVENT, LoadDefaultLocaleCommand);
            commandMap.mapEvent(LocaleEvent.PREFERRED_LOCALE_LOADED_EVENT, LoadConfigCommand);
			commandMap.mapEvent(ConfigLoadEvent.CONFIG_LOADED_EVENT, CompareLocaleVersionCommand);
            commandMap.mapEvent(ConfigVersionEvent.CONFIG_VERSION_SAME_EVENT, LoadAllModuleCommand);
            commandMap.mapEvent(ModuleLoadedEvent.MODULE_LOADED_EVENT, LoadAllModuleCommand);
            commandMap.mapEvent(AllModulesLoadedEvent.ALL_MODULES_LOADED_EVENT, JoinUserCommand);
            commandMap.mapEvent(UserAuthenticatedEvent.USER_AUTHENTICATED_EVENT, ConnectToRed5BBBCommand);
            commandMap.mapEvent(ConnectedToRed5Event.CONNECTED_TO_RED5_EVENT, GetMyUserIdCommand);
            commandMap.mapEvent(UsersConnectionEvent.CONNECTION_SUCCESS, GetAllUsersCommand);
            commandMap.mapEvent(GotAllUsersEvent.GOT_ALL_USERS_EVENT, ListenForUserMessagesCommand);
            commandMap.mapEvent(ListeningForUserMessagesEvent.LISTENING_FOR_USER_MESSAGES_EVENT, StartAllModulesCommand);
            
            
            commandMap.mapEvent(SwitchLocaleEvent.SWITCH_TO_NEW_LOCALE_EVENT, SwitchLocaleCommand);
            
            contextView.addChild(new BigBlueButtonAppShell());
            
            dispatchEvent(new ContextEvent(ContextEvent.STARTUP_COMPLETE));
                
        }
    }
}