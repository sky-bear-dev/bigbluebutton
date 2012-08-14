package org.bigbluebutton.core.modules.services
{
  import flash.events.IEventDispatcher;
  import flash.utils.Dictionary;
  
  import mx.collections.ArrayCollection;
  
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.core.modules.events.ModuleLoadEvent;
  import org.bigbluebutton.core.modules.model.DependencyResolver;
  import org.bigbluebutton.core.modules.model.ModuleDescriptor;
  import org.bigbluebutton.core.modules.model.ModulesModel;

  public class ModuleLoaderService
  {
    public var dispatcher:IEventDispatcher; 
    public var modulesModel:ModulesModel;

    public function startAllModules():void {
      LogUtil.debug("Starting all modules...............");
      modulesModel.getModuleToStart();
    }
    
        
    public function loadAllModules():void {
      LogUtil.debug("Loading all modules...............");

      modulesModel.prepareModulesForLoading();
      loadAModule();
    }
    
    public function moduleLoadedSuccessHandler(event:ModuleLoadEvent):void {
      LogUtil.debug("Module [" + event.moduleName + "] has been loaded.");
      loadAModule();
    }
    

    private function loadAModule():void {
      if (!modulesModel.allModulesLoaded()) {
        var m:ModuleDescriptor = modulesModel.getModuleToLoaded();
        if (m != null) {
          m.load();
        }
      } else {
        dispatcher.dispatchEvent(new ModuleLoadEvent(ModuleLoadEvent.MODULE_LOADED_ALL));
      }
    }
  }
}