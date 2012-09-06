package org.bigbluebutton.main.maps
{
  import flash.events.Event;
  import flash.geom.Point;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  
  import mx.controls.Alert;
  import mx.core.FlexGlobals;
  import mx.managers.PopUpManager;
  
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.core.BBB;
  import org.bigbluebutton.core.config.model.ConfigModel;
  import org.bigbluebutton.core.user.model.MeetingModel;
  import org.bigbluebutton.main.events.BBBEvent;
  import org.bigbluebutton.main.model.users.events.ConnectionFailedEvent;
  import org.bigbluebutton.main.views.LogWindow;
  import org.bigbluebutton.main.views.LoggedOutWindow;
  import org.bigbluebutton.main.views.MainCanvas;
  import org.bigbluebutton.main.views.MicSettings;
  import org.bigbluebutton.main.views.OldLocaleWarnWindow;
  import org.bigbluebutton.main.views.model.vos.LayoutOptions;
  import org.bigbluebutton.util.i18n.ResourceUtil;
  import org.bigbluebutton.util.logging.Logger;

  public class MainCanvasMediator
  {
    
    public var mainCanvas:MainCanvas;
    public var configModel:ConfigModel;
    public var meetingModel:MeetingModel;
    
    private var logs:Logger = new Logger();
    private var logWindow:LogWindow;
    
    public function openLogWindow():void {
//      Alert.show("Opening log window");
      
      if (logWindow == null){
        Alert.show("Creating log window");
        logWindow = new LogWindow();
        logWindow.logs = logs;
      }
      Alert.show("Add log window");
      if (logWindow == null) Alert.show("Log window is null");
      if (mainCanvas == null) Alert.show("Main canvas is null");
      
      mainCanvas.windowManager.add(logWindow);
      mainCanvas.windowManager.absPos(logWindow, 50, 50);
      logWindow.width = mainCanvas.width - 100;
      logWindow.height = mainCanvas.height - 100;
      Alert.show("Added log window");
    }
    
    public function checkLocaleVersion(localeVersion:String):void {	   			
      Alert.okLabel ="OK";
      var version:String = "old-locales";
      version = ResourceUtil.getInstance().getString('bbb.mainshell.locale.version');
      LogUtil.debug("Locale from config=" + localeVersion + ", from locale file=" + version);
      
      if ((version == "old-locales") || (version == "") || (version == null)) {
        wrongLocaleVersion();
      } else {
        if (version != localeVersion) wrongLocaleVersion();
      }	   			
    }
    
    private function showMicSettings(event:BBBEvent):void {
      var micSettings:MicSettings = MicSettings(PopUpManager.createPopUp(mainCanvas, MicSettings, true));				
      var point1:Point = new Point();
      // Calculate position of TitleWindow in Application's coordinates. 
      point1.x = mainCanvas.width/2;
      point1.y = mainCanvas.height/2;                
      micSettings.x = point1.x - (micSettings.width/2);
      micSettings.y = point1.y - (micSettings.height/2);	
    }
    
    private function wrongLocaleVersion():void {
      var localeWindow:OldLocaleWarnWindow = OldLocaleWarnWindow(PopUpManager.createPopUp(mainCanvas, OldLocaleWarnWindow, false));
      
      var point1:Point = new Point();
      // Calculate position of TitleWindow in Application's coordinates. 
      point1.x = mainCanvas.width/2;
      point1.y = mainCanvas.height/2;              
      localeWindow.x = point1.x - (localeWindow.width/2);
      localeWindow.y = point1.y - (localeWindow.height/2);	
    }
    
    private var logoutWindow:LoggedOutWindow;
    
    private function handleLogout(e:ConnectionFailedEvent):void {
      var layoutOptions:LayoutOptions = new LayoutOptions(configModel);
      
      if (layoutOptions.showLogoutWindow) {
        if (logoutWindow != null) return;
        logoutWindow = LoggedOutWindow(PopUpManager.createPopUp( mainCanvas, LoggedOutWindow, false));
        
        var point1:Point = new Point();
        // Calculate position of TitleWindow in Application's coordinates. 
        point1.x = mainCanvas.width/2;
        point1.y = mainCanvas.height/2;                 
        logoutWindow.x = point1.x - (logoutWindow.width/2);
        logoutWindow.y = point1.y - (logoutWindow.height/2);
        
        if (e is ConnectionFailedEvent) logoutWindow.setReason((e as ConnectionFailedEvent).type);
        else logoutWindow.setReason("You have logged out of the conference");	
        
        mainCanvas.removeAllWindows(); 				
      } else {
        mainCanvas.removeAllWindows();
        var pageHost:String = FlexGlobals.topLevelApplication.url.split("/")[0];
        var pageURL:String = FlexGlobals.topLevelApplication.url.split("/")[2];
        var request:URLRequest = new URLRequest(pageHost + "//" + pageURL + "/bigbluebutton/api/signOut");
        var urlLoader:URLLoader = new URLLoader();
        urlLoader.addEventListener(Event.COMPLETE, handleLogoutComplete);	
        urlLoader.load(request);
      }				
    }
    
    private function handleLogoutComplete(e:Event):void {	
      var url:String = meetingModel.meeting.logoutURL;
      
      var request:URLRequest = new URLRequest(url);
      LogUtil.debug("Logging out to: " + url);
      mainCanvas.logout(request);			
    }
  }
}