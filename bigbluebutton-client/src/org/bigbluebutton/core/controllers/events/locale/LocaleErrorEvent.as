package org.bigbluebutton.core.controllers.events.locale
{
    import flash.events.Event;
    
    public class LocaleErrorEvent extends Event
    {
        public static const IO_ERROR_EVENT: String = "locale io error event";
        public static const SECURITY_ERROR_EVENT: String = "locale security error event";
        
        public function LocaleErrorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}