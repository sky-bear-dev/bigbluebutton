package org.bigbluebutton.core.model.imp
{
	import flash.events.Event;
	
	import mx.collections.ArrayCollection;
	import mx.resources.IResourceManager;
	import mx.resources.ResourceManager;
	
	import org.bigbluebutton.core.Utils;
	import org.bigbluebutton.core.controllers.events.locale.LocaleEvent;
	import org.bigbluebutton.core.model.vo.LocaleCode;
	import org.robotlegs.mvcs.Actor;

    public class LocaleModel extends Actor
    {
        private static var MASTER_LOCALE:String = "en_US";
        private var _preferredLocale: String = MASTER_LOCALE;
        private static var BBB_RESOURCE_BUNDLE:String = 'bbbResources';
        
        private var _resourceManager:IResourceManager = ResourceManager.getInstance();;
        
        private var _locales:ArrayCollection = new ArrayCollection();
       
		public function get locals():ArrayCollection {
			return _locales;
		}
		
		public function addLocale(locale: LocaleCode):void {
            _locales.addItem(locale);
        }
        
        public function get masterLocale():String {
            return MASTER_LOCALE;
        }
        
        public function get preferredLocale():String {
            return _preferredLocale;
        }
        
        public function get resourceManager():IResourceManager {
            return _resourceManager;
        }
        
        public function localeLoaded(code: String):void {
            var e: LocaleEvent;
            
            if (code == MASTER_LOCALE) {
                resourceManager.localeChain = [MASTER_LOCALE];
                e = new LocaleEvent(LocaleEvent.MASTER_LOCALE_LOADED_EVENT);
                e.loadedLocale = code;
                dispatch(e);
            } else {
                resourceManager.localeChain = [code, MASTER_LOCALE];
                e = new LocaleEvent(LocaleEvent.PREFERRED_LOCALE_LOADED_EVENT);
                e.loadedLocale = code;
                dispatch(e);
            }     
            
            update();
        }
        
        public function localeLoadingFailed(code: String):void {
            resourceManager.localeChain = [MASTER_LOCALE];
            update();
        }
        
        public function update():void{
            dispatch(new Event(Event.CHANGE));
        }
        
        [Bindable("change")]
        public function getString(resourceName:String, parameters:Array = null, locale:String = null):String{
            /**
             * Get the translated string from the current locale. If empty, get the string from the master
             * locale. Locale chaining isn't working because mygengo actually puts the key and empty value
             * for untranslated strings into the locale file. So, when Flash does a lookup, it will see that
             * the key is available in the locale and thus not bother falling back to the master locale.
             *    (ralam dec 15, 2011).
             */
            var localeTxt:String = resourceManager.getString(BBB_RESOURCE_BUNDLE, resourceName, parameters, null);
            if ((localeTxt == "") || (localeTxt == null)) {
                localeTxt = resourceManager.getString(BBB_RESOURCE_BUNDLE, resourceName, parameters, MASTER_LOCALE);
            }
            return localeTxt;
        }
    }
}