package org.bigbluebutton.core.config.services
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.core.config.events.ConfigEvent;
  import org.bigbluebutton.core.config.model.ConfigModel;
  import org.bigbluebutton.core.model.Config;

  public class ConfigLoaderService
  {
    public var dispatcher:IEventDispatcher;    
    public var model:ConfigModel;
       
    public function loadConfig():void {
      LogUtil.debug("ConfigLoaderService: Loading config.xml");
      var urlLoader:URLLoader = new URLLoader();
      urlLoader.addEventListener(Event.COMPLETE, handleComplete);
      var date:Date = new Date();
      urlLoader.load(new URLRequest("conf/config.xml" + "?a=" + date.time));			
    }		
    
    private function handleComplete(e:Event):void{
      LogUtil.debug("ConfigLoaderService: handling loaded config.xml");
      model.config =  new Config(new XML(e.target.data));
      dispatcher.dispatchEvent(new ConfigEvent(ConfigEvent.CONFIG_LOADED));	
    }    
  }
}