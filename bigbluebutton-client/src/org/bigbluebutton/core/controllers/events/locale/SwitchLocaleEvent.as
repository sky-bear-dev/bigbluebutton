package org.bigbluebutton.core.controllers.events.locale
{
    import flash.events.Event;
    
    public class SwitchLocaleEvent extends Event
    {
        public var newLocale: String;
        
        public static const SWITCH_TO_NEW_LOCALE_EVENT: String = "switch to new locale event";
        
        public function SwitchLocaleEvent(bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(SWITCH_TO_NEW_LOCALE_EVENT, bubbles, cancelable);
        }
    }
}