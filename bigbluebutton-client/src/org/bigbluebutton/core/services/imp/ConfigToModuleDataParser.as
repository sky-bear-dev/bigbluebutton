package org.bigbluebutton.core.services.imp
{
	import flash.utils.Dictionary;
	
	import org.bigbluebutton.core.vo.ModuleDescriptor;

	public class ConfigToModuleDataParser
	{
		public function parseConfig(xml:XML):void{
			var _modules:Dictionary = new Dictionary();
			var list:XMLList = xml.modules.module;
			var item:XML;
			for each(item in list){
				var mod:ModuleDescriptor = new ModuleDescriptor(item);
				_modules[item.@name] = mod;
			}
		}
		
		private function parseAttributes():void {
			
		}
		
		private function parseDependencies():void {
			
		}
	}
}