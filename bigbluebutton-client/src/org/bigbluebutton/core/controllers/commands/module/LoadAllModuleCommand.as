package org.bigbluebutton.core.controllers.commands.module
{
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.core.model.imp.ModuleModel;
    import org.bigbluebutton.core.model.vo.ModuleDescriptor;
    import org.bigbluebutton.core.services.imp.ModuleLoaderService;
    import org.robotlegs.mvcs.Command;
    
    public class LoadAllModuleCommand extends Command
    {
        [Inject]
        public var moduleModel:ModuleModel;
        
        [Inject]
        public var service:ModuleLoaderService;
        
        [Inject]
        public var logger:Logger;
        
        override public function execute():void
        {
            
            if (moduleModel.allModulesLoaded()) {
                
            } else {
                var mod:ModuleDescriptor = moduleModel.getNextModuleToLoad();
                if (mod != null) {
                    logger.debug("Loading " + mod.name);
                    service.load(mod);
                }
            }
        }
    }
}