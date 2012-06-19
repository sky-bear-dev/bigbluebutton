package org.bigbluebutton.core.services.imp
{
    import flash.events.IEventDispatcher;
    
    import mx.events.ResourceEvent;
    
    import org.bigbluebutton.core.controllers.events.locale.LocaleEvent;
    import org.bigbluebutton.core.model.imp.LocaleModel;
    import org.robotlegs.mvcs.Actor;

    public class LocaleLoaderService extends Actor
    {
        private var resEventDispatcher:IEventDispatcher;
        
        [Inject]
        public var localeModel: LocaleModel;
        
        private var _localeBeingLoaded:String;
        
        public function loadLocaleResource(locale:String):void {    
            // Add a random string on the query so that we don't get a cached version.            
            var date:Date = new Date();
            var localeURI:String = 'locale/' + locale + '_resources.swf?a=' + date.time;            
            
            // Store the locale being loaded. We need this to dispatch when we get the loading result.
            _localeBeingLoaded = locale;
            
            resEventDispatcher = localeModel.resourceManager.loadResourceModule(localeURI, false);
            resEventDispatcher.addEventListener(ResourceEvent.COMPLETE, localeChangeComplete);
            resEventDispatcher.addEventListener(ResourceEvent.ERROR, handleResourceNotLoaded);
        }
        
        private function localeChangeComplete(event:ResourceEvent):void {
            localeModel.localeLoaded(_localeBeingLoaded);
        }
        
  
        private function handleResourceNotLoaded(event:ResourceEvent):void{
            localeModel.localeLoadingFailed(_localeBeingLoaded);
            var e: LocaleEvent = new LocaleEvent(LocaleEvent.LOAD_LOCALE_FAILED_EVENT);
            e.loadedLocale = _localeBeingLoaded;
            dispatch(e);
        }
        

    }
}