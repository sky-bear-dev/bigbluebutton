package org.bigbluebutton.main.events
{
  import flash.events.Event;
  
  public class LogWindowEvent extends Event
  {
    public static const OPEN_LOG_WINDOW:String = "open log window";
    public static const CLOSE_LOG_WINDOW:String = "close log window";
    
    public function LogWindowEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
  }
}