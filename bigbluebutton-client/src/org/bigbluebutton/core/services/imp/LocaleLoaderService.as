package org.bigbluebutton.core.services.imp
{
    import flash.events.Event;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import mx.resources.IResourceManager;
    import mx.resources.ResourceManager;
    
    import org.bigbluebutton.core.services.ILocaleService;
    import org.robotlegs.mvcs.Actor;

    public class LocaleLoaderService  extends Actor implements ILocaleService
    {
        public static const LOCALES_FILE:String = "conf/locales.xml";
        public static const VERSION:String = "0.8";
        private var inited:Boolean = false;
        
        private static var BBB_RESOURCE_BUNDLE:String = 'bbbResources';
        private static var MASTER_LOCALE:String = "en_US";
        
        [Bindable] public var localeCodes:Array = new Array();
        [Bindable] public var localeNames:Array = new Array();
        
        private var resourceManager:IResourceManager;
        
        public function LocaleLoaderService()
        {
            resourceManager = ResourceManager.getInstance();
        }
        
        public function determineAvailableLocales():void {            
            // Add a random string on the query so that we always get an up-to-date config.xml
            var date:Date = new Date();
            var _urlLoader:URLLoader = new URLLoader();
            _urlLoader.addEventListener(Event.COMPLETE, handleComplete);
            _urlLoader.load(new URLRequest(LOCALES_FILE + "?a=" + date.time));
        }
        
        private function handleComplete(e:Event):void{
            parse(new XML(e.target.data));		
        }
        
        private function parse(xml:XML):void{		 	
            var list:XMLList = xml.locale;
            var locale:XML;
            
            for each(locale in list){
                localeCodes.push(locale.@code);
                localeNames.push(locale.@name);
            }							
        }
    }
}