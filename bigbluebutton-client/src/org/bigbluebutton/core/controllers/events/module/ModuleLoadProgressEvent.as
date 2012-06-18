package org.bigbluebutton.core.controllers.events.module
{
    import flash.events.Event;
    
    public class ModuleLoadProgressEvent extends Event
    {
        public function ModuleLoadProgressEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}