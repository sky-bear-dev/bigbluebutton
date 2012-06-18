package org.bigbluebutton.core.controllers.events
{
    import flash.events.Event;
    
    public class LocaleErrorEvent extends Event
    {
        public function LocaleErrorEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(type, bubbles, cancelable);
        }
    }
}