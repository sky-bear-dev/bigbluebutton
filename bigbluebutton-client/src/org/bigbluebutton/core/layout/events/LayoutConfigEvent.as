package org.bigbluebutton.core.layout.events
{
  import flash.events.Event;
  
  public class LayoutConfigEvent extends Event
  {
    public static const LAYOUT_CONFIG_LOADED:String = "layout config loaded event";
    
    public function LayoutConfigEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
  }
}