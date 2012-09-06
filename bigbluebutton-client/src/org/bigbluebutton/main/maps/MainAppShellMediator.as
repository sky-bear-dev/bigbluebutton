package org.bigbluebutton.main.maps
{
  import mx.controls.Alert;
  
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.main.views.LogWindow;
  import org.bigbluebutton.main.views.MainCanvas;
  import org.bigbluebutton.util.logging.Logger;
  
  public class MainAppShellMediator
  {

    private var logs:Logger = new Logger();
    private var logWindow:LogWindow;
    
    public function openLogWindow(mainCanvas:MainCanvas):void {
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
    //  logWindow.width = mainCanvas.width - 100;
    //  logWindow.height = mainCanvas.height - 100;
      logWindow.width = 800;
      logWindow.height = 600;
      Alert.show("Added log window [" + logWindow.width + "x" + logWindow.height + "]");
//      mainCanvas.openLogWindow();
    }
    
    public function appVersionHandler():void {
      Alert.show("Handle App version.");
      
      LogUtil.debug("Handle App version.");
    }
  }
}