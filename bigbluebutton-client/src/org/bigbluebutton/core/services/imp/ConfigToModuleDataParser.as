package org.bigbluebutton.core.services.imp
{	
	import flash.utils.Dictionary;
	
	import mx.collections.ArrayCollection;
	import mx.utils.StringUtil;
	
	import org.bigbluebutton.core.model.imp.ModuleModel;
	import org.bigbluebutton.core.model.vo.ModuleDescriptor;

	public class ConfigToModuleDataParser
	{
        [Inject]
        public var moduleModel:ModuleModel;
        
        [Inject]
        public var dependencyResolver:ModuleDependencyResolver;
        
		public function parseConfig(xml:XML):void{
			var modules:Dictionary = new Dictionary();
			var list:XMLList = xml.modules.module;
			var item:XML;
			for each(item in list){
				var mod:ModuleDescriptor = new ModuleDescriptor();
                mod.attributes = parseAttributes(item);
                mod.unresolvedDependencies = parseDependencies(mod.attributes);
				modules[item.@name] = mod;
			}
            
            moduleModel.modules = modules;
            moduleModel.sortedDependencies = dependencyResolver.buildDependencyTree(moduleModel.modules);           
		}
		
        private function parseAttributes(item:XML):Object {
            var attNamesList:XMLList = item.@*;
            var attributes:Object = new Object();
            
            for (var i:int = 0; i < attNamesList.length(); i++)
            { 
                var attName:String = attNamesList[i].name();
                var attValue:String = item.attribute(attName);
                attributes[attName] = attValue;
            }   
            
            return attributes;
        }
		
		private function parseDependencies(attributes:Object):ArrayCollection {
            var dependString:String = attributes["dependsOn"] as String;
            if (dependString == null) return new ArrayCollection();
            
            var trimmedString:String = StringUtil.trimArrayElements(dependString, ",");
            var dependencies:Array = trimmedString.split(",");
            var unresolvedDependancies:ArrayCollection = new ArrayCollection();
            
            for (var i:int = 0; i < dependencies.length; i++){
                unresolvedDependancies.addItem(dependencies[i]);
            }		
            
            return unresolvedDependancies;
		}
	}
}