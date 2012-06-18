package org.bigbluebutton.core.controllers.events.config
{
    import flash.events.Event;
    
    public class ConfigLoadedEvent extends Event
    {
        public static const CONFIG_LOADED_EVENT:String = "bbb config loaded event";
        
        public function ConfigLoadedEvent(bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(CONFIG_LOADED_EVENT, bubbles, cancelable);
        }
    }
}