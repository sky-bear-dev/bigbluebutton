package org.bigbluebutton.core.services.imp
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    
    import org.bigbluebutton.core.controllers.events.locale.LocaleErrorEvent;
    import org.bigbluebutton.core.controllers.events.locale.LocaleEvent;
    import org.bigbluebutton.core.model.imp.LocaleModel;
    import org.bigbluebutton.core.model.vo.LocaleCode;
    import org.bigbluebutton.core.services.ILocaleService;
    import org.robotlegs.mvcs.Actor;

    public class LocaleConfigLoaderService  extends Actor
    {
        public static const LOCALES_FILE:String = "conf/locales.xml";
      
        [Inject]
        private var localeModel: LocaleModel;
                
        public function determineAvailableLocales():void {            
            var _urlLoader:URLLoader = new URLLoader();
            _urlLoader.addEventListener(Event.COMPLETE, handleComplete);
            _urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOErrorEvent);
            _urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityErrorEvent);
            
            // Add a random string on the query so that we always get an up-to-date config.xml
            var date:Date = new Date();            
            _urlLoader.load(new URLRequest(LOCALES_FILE + "?a=" + date.time));
        }
        
        private function handleComplete(e:Event):void {
            parse(new XML(e.target.data));		
        }
        
        private function parse(xml:XML):void {		 	
            var list: XMLList = xml.locale;
            var locale: XML;
            
            for each(locale in list){
                var localCode: LocaleCode = new LocaleCode(locale.@code, locale.@name);
                localeModel.addLocale(localCode);
            }				
            
            dispatch(new LocaleEvent(LocaleEvent.LIST_OF_AVAILABLE_LOCALES_LOADED_EVENT));
        }
        
        private function handleIOErrorEvent(e: Event):void {
            dispatch(new LocaleErrorEvent(LocaleErrorEvent.IO_ERROR_EVENT));
        }
        
        private function handleSecurityErrorEvent(e: Event):void {
            dispatch(new LocaleErrorEvent(LocaleErrorEvent.SECURITY_ERROR_EVENT));
        }
    }
}