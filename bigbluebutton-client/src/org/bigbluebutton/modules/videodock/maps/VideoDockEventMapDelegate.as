package org.bigbluebutton.modules.videodock.maps
{
  import flash.events.IEventDispatcher;
  
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.common.events.OpenWindowEvent;
  import org.bigbluebutton.core.modules.events.ModuleEvent;
  import org.bigbluebutton.modules.videodock.views.VideoDock;

  public class VideoDockEventMapDelegate
  {
    public var dispatcher:IEventDispatcher;
    public var videoDock:VideoDock;
    
    public function moduleStart(event:ModuleEvent):void {
      LogUtil.debug("Opening Video Dock Window");
      var windowEvent:OpenWindowEvent = new OpenWindowEvent(OpenWindowEvent.OPEN_WINDOW_EVENT);
      windowEvent.window = videoDock;
      dispatcher.dispatchEvent(windowEvent);      
    }

  }
}