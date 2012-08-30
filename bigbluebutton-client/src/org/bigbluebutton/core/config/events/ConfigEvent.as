package org.bigbluebutton.core.config.events
{
  import flash.events.Event;
  
  public class ConfigEvent extends Event
  {
    public static const CONFIG_LOADED:String = "config loaded event";
    
    public function ConfigEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
  }
}