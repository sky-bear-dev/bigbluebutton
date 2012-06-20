package org.bigbluebutton.core.controllers.events.module
{
    import flash.events.Event;
    
    public class ModuleLoadedEvent extends Event
    {
        public static const MODULE_LOADED_EVENT:String = "module loaded event";
        
        public var name:String;
        
        public function ModuleLoadedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}