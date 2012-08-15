package org.bigbluebutton.core.modules.events
{
  import flash.events.Event;
  
  public class ModuleEvent extends Event
  {
    public static const MODULE_START:String = "module start event";
    public static const MODULE_STARTED:String = "module started event";
    public static const MODULE_STOP:String = "module stop event";
    public static const MODULE_STOPPED:String = "module stopped event";
    
    public var name:String;
    
    public function ModuleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {
      super(type, bubbles, cancelable);
    }
  }
}