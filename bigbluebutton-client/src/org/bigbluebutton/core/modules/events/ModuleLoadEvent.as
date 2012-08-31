package org.bigbluebutton.core.modules.events
{
  import flash.events.Event;
  
  public class ModuleLoadEvent extends Event
  {
    public static const MODULE_LOAD_START:String = "module load start event";
    public static const MODULE_LOAD_SUCCESS:String = "module load success event";
    public static const MODULE_LOAD_ERROR:String = "module load error event";
    public static const MODULE_LOAD_PROGRESS:String = "module load progress event";
    public static const MODULE_LOADED_ALL:String = "module all loaded event";
    
    public var moduleName:String;
    public var percentLoaded:Number;
    
    public function ModuleLoadEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {  
      super(type, bubbles, cancelable);
    }
  }
}