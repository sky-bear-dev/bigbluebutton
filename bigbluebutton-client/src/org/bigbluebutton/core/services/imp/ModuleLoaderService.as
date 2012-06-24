package org.bigbluebutton.core.services.imp
{
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.system.ApplicationDomain;
    
    import mx.events.ModuleEvent;
    import mx.modules.ModuleLoader;
    
    import org.bigbluebutton.core.BigBlueButtonModule;
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.core.controllers.events.module.ModuleLoadErrorEvent;
    import org.bigbluebutton.core.controllers.events.module.ModuleLoadProgressEvent;
    import org.bigbluebutton.core.controllers.events.module.ModuleLoadedEvent;
    import org.bigbluebutton.core.model.vo.ModuleDescriptor;
    import org.robotlegs.mvcs.Actor;
    import org.robotlegs.utilities.modular.core.IModule;

    public class ModuleLoaderService extends Actor
    {
        private var _currentModule:ModuleDescriptor;
        
        [Inject]
        public var logger:Logger;
        
		[Inject]
		public var bmod:BigBlueButtonModule;
		
        public function load(module:ModuleDescriptor):void { 
            _currentModule = module;
            var _loader:ModuleLoader = new ModuleLoader();
            _loader.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
            _loader.addEventListener("loading", onLoading);
            _loader.addEventListener("progress", onLoadProgress);
            _loader.addEventListener("ready", onReady);
            _loader.addEventListener("error", onErrorLoading);
            _loader.url = module.attributes.url;
            logger.debug("Loading " + _loader.url);
            _loader.loadModule();
        }
        
        private function onReady(event:Event):void {
            logger.error("Module on ready event");
            
            var modLoader:ModuleLoader = event.target as ModuleLoader;
            
            if (!(modLoader.child is BigBlueButtonModule)) {
                logger.error("Invalid module error");
                var errorEvent:ModuleLoadErrorEvent = new ModuleLoadErrorEvent(ModuleLoadErrorEvent.INVALID_MODULE_ERROR_EVENT);
                dispatch(errorEvent);
            }
            
            var bbb_module:BigBlueButtonModule = modLoader.child as BigBlueButtonModule;
            
            if (bbb_module != null) {
                _currentModule.module = bbb_module;
                _currentModule.loaded = true;
                logger.error("Module has been loaded. [" + _currentModule.name);
                var evt:ModuleLoadedEvent = new ModuleLoadedEvent(ModuleLoadedEvent.MODULE_LOADED_EVENT);
                evt.name = _currentModule.name;
                dispatch(evt);
            } else {
                logger.error("Failed to load module.");
                var loadErrorEvent:ModuleLoadErrorEvent = new ModuleLoadErrorEvent(ModuleLoadErrorEvent.FAILED_TO_LOAD_MODULE_ERROR_EVENT);
                dispatch(loadErrorEvent);
            }            
        }	
        
        private function onLoadProgress(e:ProgressEvent):void {
            var event:ModuleLoadProgressEvent = new ModuleLoadProgressEvent(ModuleLoadProgressEvent.MODULE_LOAD_PROGRESS_EVENT);
            event.moduleName = _currentModule.name;
            event.percentLoaded = Math.round((e.bytesLoaded/e.bytesTotal) * 100);
            dispatch(event);
        }	
        
        private function onErrorLoading(e:ModuleEvent):void{
            logger.error("Error loading module.");
            var loadErrorEvent:ModuleLoadErrorEvent = new ModuleLoadErrorEvent(ModuleLoadErrorEvent.FAILED_TO_LOAD_MODULE_ERROR_EVENT);
            dispatch(loadErrorEvent);
        }
        
        private function onLoading(e:Event):void{
            logger.error("Module on loading event.");
        }
    }
}