package org.bigbluebutton.core.controllers.events.module
{
	import flash.events.Event;
	
	public class AllModulesLoadedEvent extends Event
	{
		public function AllModulesLoadedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}