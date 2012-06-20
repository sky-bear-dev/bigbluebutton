package org.bigbluebutton.core.services.imp
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import org.bigbluebutton.core.controllers.events.config.ConfigLoadEvent;
	import org.bigbluebutton.core.model.imp.ConfigModel;
	import org.bigbluebutton.core.model.imp.ModuleModel;
	import org.robotlegs.mvcs.Actor;

    public class ConfigLoaderService extends Actor
    {
		public static const LOCALES_FILE:String = "conf/config.xml";
		
		[Inject]
		public var configModel:ConfigModel;
		
		[Inject]
		public var moduleParser:ConfigToModuleDataParser;
		
		public function loadConfig():void {            
			var _urlLoader:URLLoader = new URLLoader();
			_urlLoader.addEventListener(Event.COMPLETE, handleComplete);
			_urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOErrorEvent);
			_urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityErrorEvent);
			
			// Add a random string on the query so that we always get an up-to-date config.xml
			var date:Date = new Date();            
			_urlLoader.load(new URLRequest(LOCALES_FILE + "?a=" + date.time));
		}
		
		private function handleComplete(e:Event):void {
			configModel.setConfig(new XML(e.target.data));	
			moduleParser.parseConfig(new XML(e.target.data));
			dispatch(new ConfigLoadEvent(ConfigLoadEvent.CONFIG_LOADED_EVENT));
		}
				
		private function handleIOErrorEvent(e: Event):void {
			dispatch(new ConfigLoadEvent(ConfigLoadEvent.CONFIG_LOAD_ERROR_EVENT));
		}
		
		private function handleSecurityErrorEvent(e: Event):void {
			dispatch(new ConfigLoadEvent(ConfigLoadEvent.CONFIG_LOAD_ERROR_EVENT));
		}
    }
}