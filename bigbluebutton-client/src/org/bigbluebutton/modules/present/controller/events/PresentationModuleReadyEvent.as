package org.bigbluebutton.modules.present.controller.events
{
    import flash.events.Event;
    
    public class PresentationModuleReadyEvent extends Event
    {
        public static const PRESENTATION_MODULE_READY_EVENT:String = "presentation module ready event";
        
        public function PresentationModuleReadyEvent(bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(PRESENTATION_MODULE_READY_EVENT, bubbles, cancelable);
        }
    }
}