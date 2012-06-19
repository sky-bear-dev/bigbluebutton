package org.bigbluebutton.core.controllers.events.locale
{
    import flash.events.Event;
    
    public class LocaleEvent extends Event
    {
        public static const LIST_OF_AVAILABLE_LOCALES_LOADED_EVENT:String = "list of avail locale loaded event";
        public static const MASTER_LOCALE_LOADED_EVENT:String = "master locale loaded event";
        public static const PREFERRED_LOCALE_LOADED_EVENT:String = "preferred locale loaded event";
        public static const LOAD_LOCALE_FAILED_EVENT:String = "load locale failed event";
        
        public var loadedLocale: String;
        
        public function LocaleEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}