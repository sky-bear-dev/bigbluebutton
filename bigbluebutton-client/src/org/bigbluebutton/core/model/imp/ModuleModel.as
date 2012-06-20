package org.bigbluebutton.core.model.imp
{
    import flash.utils.Dictionary;
    
    import mx.collections.ArrayCollection;
    
    import org.bigbluebutton.core.model.vo.ModuleDescriptor;

    public class ModuleModel
    {
        private var _modules:Dictionary;
        private var _sortedDependecies:ArrayCollection;
        
        public function set modules(m:Dictionary):void {
            _modules = m;
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