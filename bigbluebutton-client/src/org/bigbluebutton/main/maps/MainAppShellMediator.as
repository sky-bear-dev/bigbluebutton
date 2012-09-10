package org.bigbluebutton.main.maps
{
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.common.events.OpenWindowEvent;
  import org.bigbluebutton.main.views.LogWindow;
  import org.bigbluebutton.util.logging.Logger;
  
  public class MainAppShellMediator
  {  
    public function displayDefaultLayout():void {
      LogUtil.debug("Display default layout!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!");
    }
    
    public function openWindowEventHandler(event:OpenWindowEvent):void {
      LogUtil.debug("****************** MainAppShellMediator: Received Open Window Event *************************************");
      //  LogUtil.debug("Opening Window [" + event.window.getWindowID() + "]");
    }
  }
}