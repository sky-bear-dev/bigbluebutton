package org.bigbluebutton.core.services.imp
{
    import flash.events.Event;
    import flash.events.IOErrorEvent;
    import flash.events.SecurityErrorEvent;
    import flash.net.URLLoader;
    import flash.net.URLRequest;
    
    import org.bigbluebutton.core.controllers.events.JoinErrorEvent;
    import org.bigbluebutton.core.model.imp.ConfigModel;
    import org.robotlegs.mvcs.Actor;

    public class JoinService extends Actor
    {
   
        public static const LOCALES_FILE:String = "conf/config.xml";
        
        [Inject]
        public var configModel:ConfigModel;
        
        [Inject]
        public var joinParser:JoinServiceXmlParser;
        
        public function join():void {            
            var _urlLoader:URLLoader = new URLLoader();
            _urlLoader.addEventListener(Event.COMPLETE, handleComplete);
            _urlLoader.addEventListener(IOErrorEvent.IO_ERROR, handleIOErrorEvent);
            _urlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, handleSecurityErrorEvent);
            
            // Add a random string on the query so that we always get an up-to-date config.xml
            var date:Date = new Date();            
            _urlLoader.load(new URLRequest(configModel.enterApiURI + "?a=" + date.time));
        }
        
        private function handleComplete(e:Event):void {
            joinParser.parseJoinServiceResult(new XML(e.target.data));
        }
        
        private function handleIOErrorEvent(e: Event):void {
            dispatch(new JoinErrorEvent());
        }
        
        private function handleSecurityErrorEvent(e: Event):void {
            dispatch(new JoinErrorEvent())
        }
    }
}