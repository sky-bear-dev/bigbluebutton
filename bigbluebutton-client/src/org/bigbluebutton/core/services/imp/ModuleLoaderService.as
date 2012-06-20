package org.bigbluebutton.core.services.imp
{
    import flash.events.Event;
    import flash.events.ProgressEvent;
    import flash.system.ApplicationDomain;
    
    import mx.events.ModuleEvent;
    
    import org.bigbluebutton.common.IBigBlueButtonModule;
    import org.bigbluebutton.core.controllers.events.module.ModuleLoadErrorEvent;
    import org.bigbluebutton.core.controllers.events.module.ModuleLoadProgressEvent;
    import org.bigbluebutton.core.controllers.events.module.ModuleLoadedEvent;
    import org.bigbluebutton.core.model.vo.ModuleDescriptor;
    import org.robotlegs.mvcs.Actor;   
    import mx.modules.ModuleLoader;

    public class ModuleLoaderService extends Actor
    {
        private var _loader:ModuleLoader;
        private var _currentModule:ModuleDescriptor;
        
        public function load(module:ModuleDescriptor):void { 
            _currentModule = module;
            _loader.applicationDomain = new ApplicationDomain(ApplicationDomain.currentDomain);
            _loader.addEventListener("loading", onLoading);
            _loader.addEventListener("progress", onLoadProgress);
            _loader.addEventListener("ready", onReady);
            _loader.addEventListener("error", onErrorLoading);
            _loader.url = module.attributes.url;
            _loader.loadModule();
        }
        
        private function onReady(event:Event):void {
            var modLoader:ModuleLoader = event.target as ModuleLoader;
            
            if (!(modLoader.child is IBigBlueButtonModule)) {
                var errorEvent:ModuleLoadErrorEvent = new ModuleLoadErrorEvent(ModuleLoadErrorEvent.INVALID_MODULE_ERROR_EVENT);
                dispatch(errorEvent);
            }
            
            _currentModule.module = modLoader.child as IBigBlueButtonModule;
            if (_currentModule != null) {
                _currentModule.loaded = true;
                var evt:ModuleLoadedEvent = new ModuleLoadedEvent(ModuleLoadedEvent.MODULE_LOADED_EVENT);
                evt.name = _currentModule.name;
                dispatch(evt);
            } else {
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
            var loadErrorEvent:ModuleLoadErrorEvent = new ModuleLoadErrorEvent(ModuleLoadErrorEvent.FAILED_TO_LOAD_MODULE_ERROR_EVENT);
            dispatch(loadErrorEvent);
        }
        
        private function onLoading(e:Event):void{
            //			LogUtil.debug(getName() + " is loading");
        }
    }
}