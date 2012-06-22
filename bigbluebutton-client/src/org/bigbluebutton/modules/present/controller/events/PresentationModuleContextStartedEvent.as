package org.bigbluebutton.modules.present.controller.events
{
    import flash.events.Event;
    
    public class PresentationModuleContextStartedEvent extends Event
    {
        public static const PRESENTATION_MODULE_CONTEXT_STARTED_EVENT:String = "presentation module context started event";
        
        public function PresentationModuleContextStartedEvent(bubbles:Boolean=false, cancelable:Boolean=false)
        {
            super(PRESENTATION_MODULE_CONTEXT_STARTED_EVENT, bubbles, cancelable);
        }
    }
}