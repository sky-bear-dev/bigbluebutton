package org.bigbluebutton.main.views
{
    import flash.events.Event;
    
    public class LogButtonClickedEvent extends Event
    {
        public static const LOG_BUTTON_CLICKED_EVENT:String = "log button clicked event";
        
        public function LogButtonClickedEvent(bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(LOG_BUTTON_CLICKED_EVENT, bubbles, cancelable);
        }
    }
}