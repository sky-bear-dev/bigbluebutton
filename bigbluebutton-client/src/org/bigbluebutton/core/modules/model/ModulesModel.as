package org.bigbluebutton.core.modules.model
{
  import flash.events.IEventDispatcher;
  import flash.utils.Dictionary;
  
  import mx.collections.ArrayCollection;
  
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.core.config.model.ConfigModel;


  public class ModulesModel
  {
    public var dispatcher:IEventDispatcher;
    public var configModel:ConfigModel;
    
    private var _modules:Dictionary;
    private var _numberOfModules:int = 0;
    private var _sortedModules:ArrayCollection;
   
    public function prepareModulesForLoading():void {
      var modules:Dictionary = getModules();
      
      for (var key:Object in modules) {
        var m:ModuleDescriptor = modules[key] as ModuleDescriptor;
        m.dispatcher = dispatcher;
      }
      
      var resolver:DependencyResolver = new DependencyResolver();
      _sortedModules = resolver.buildDependencyTree(modules);
    }
    
    private function getModulesXML():XMLList {
      var modulesXML:XML = configModel.config.getModules();
      LogUtil.debug("ModulesModel modules " + modulesXML.toString());
      return modulesXML.module;
    }
    
    private function buildModuleDescriptors():Dictionary {
      _modules = new Dictionary();
      var list:XMLList = getModulesXML();
      var item:XML;
      for each(item in list) {
        LogUtil.debug(item.toString());
        var mod:ModuleDescriptor = new ModuleDescriptor(item);
        _modules[item.@name] = mod;
        _numberOfModules++;
      }
      return _modules;
    }
    
    public function getModules():Dictionary {
      buildModuleDescriptors();
      return _modules;
    }
    
    public function getModule(name:String):ModuleDescriptor {
      for (var key:Object in _modules) {				
        var m:ModuleDescriptor = _modules[key] as ModuleDescriptor;
        if (m.getName() == name) {
          return m;
        }
      }		
      return null;	
    }
    
    public function getModuleToLoaded():ModuleDescriptor {
      for (var i:int = 0; i < _sortedModules.length; i++){
        var m:ModuleDescriptor = _sortedModules.getItemAt(i) as ModuleDescriptor;
        if (!m.loaded){
          return m;
        } 
      }
      return null;
    }
    
    public function allModulesLoaded():Boolean{
      for (var i:int = 0; i < _sortedModules.length; i++){
        var m:ModuleDescriptor = _sortedModules.getItemAt(i) as ModuleDescriptor;
        if (!m.loaded){
          return false;
        } 
      }
      return true;
    }
    
  }
}