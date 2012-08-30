package org.bigbluebutton.main.events
{
  import flash.events.Event;
  
  public class LocaleEvent extends Event
  {
    public static const LOCALE_INITIALIZED:String = "locale initialized event";
    
    public function LocaleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
  }
}