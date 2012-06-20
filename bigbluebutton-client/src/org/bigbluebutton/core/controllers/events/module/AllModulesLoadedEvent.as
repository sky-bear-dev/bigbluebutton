package org.bigbluebutton.core.controllers.events.module
{
	import flash.events.Event;
	
	public class AllModulesLoadedEvent extends Event
	{
        public static const ALL_MODULES_LOADED_EVENT:String = "all modules loaded event";
        
		public function AllModulesLoadedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}