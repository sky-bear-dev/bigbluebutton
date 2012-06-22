package org.bigbluebutton.core.model.imp
{
    import flash.utils.Dictionary;
    
    import mx.collections.ArrayCollection;
    
    import org.bigbluebutton.core.BigBlueButtonModule;
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.core.model.vo.ModuleDescriptor;

    public class ModuleModel
    {
        [Inject]
        public var logger:Logger;
        
        private var _modules:Dictionary;
        private var _sortedDependecies:ArrayCollection;
        
        public function set modules(m:Dictionary):void {
            _modules = m;
        }
        
        public function startAllModules():void{
            for (var i:int = 0; i < _sortedDependecies.length; i++){
                var m:ModuleDescriptor = _sortedDependecies.getItemAt(i) as ModuleDescriptor;
                startModule(m.name);
            }
        }
        
        private function getModule(name:String):ModuleDescriptor {
            for (var key:Object in _modules) {				
                var m:ModuleDescriptor = _modules[key] as ModuleDescriptor;
                if (m.name == name) {
                    return m;
                }
            }		
            return null;	
        }
        
        private function startModule(name:String):void {
            var m:ModuleDescriptor = getModule(name);
            if (m != null) {
                logger.debug('Starting module ' + name);
                var bbb:BigBlueButtonModule = m.module as BigBlueButtonModule;
                bbb.start();		
            }	
        }
        
        public function get modules():Dictionary {
            return _modules;
        }
        
        public function set sortedDependencies(dependencies:ArrayCollection):void {
            _sortedDependecies = dependencies;
        }
        
        public function get sortedDependencies():ArrayCollection {
            return _sortedDependecies;
        }
        
        public function getNextModuleToLoad():ModuleDescriptor {
            for (var i:int = 0; i < _sortedDependecies.length; i++){
                var m:ModuleDescriptor = _sortedDependecies.getItemAt(i) as ModuleDescriptor;
                if (!m.loaded){
                    return m;
                } 
            }
            return null;
        }
        
        public function allModulesLoaded():Boolean{
            for (var i:int = 0; i < _sortedDependecies.length; i++){
                var m:ModuleDescriptor = _sortedDependecies.getItemAt(i) as ModuleDescriptor;
                if (!m.loaded){
                    return false;
                } 
            }
            return true;
        }
    }
}