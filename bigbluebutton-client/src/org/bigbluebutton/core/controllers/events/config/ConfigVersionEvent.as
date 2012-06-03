package org.bigbluebutton.core.controllers.events.config
{
	import flash.events.Event;
	
	public class ConfigVersionEvent extends Event
	{
		public static const CONFIG_VERSION_SAME_EVENT:String = "config version same event";
		public static const CONFIG_VERSION_NOT_SAME_EVENT:String = "config version not same event";
		
		public function ConfigVersionEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
		}
	}
}