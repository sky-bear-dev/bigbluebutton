package org.bigbluebutton.core.layout.services
{
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.core.BBB;
  import org.bigbluebutton.core.layout.events.LayoutsLoadedEvent;
  import org.bigbluebutton.core.layout.model.LayoutLoader;
  import org.bigbluebutton.core.layout.model.LayoutModel;

  public class LayoutLoaderService
  {
    public var layoutModel:LayoutModel;
    
    public function LayoutLoaderService()
    {
      LogUtil.debug("*************************** LayoutLoaderService model inited. **********************");
    }
      
    public function loadServerLayouts():void {
      var layoutUrl:String = "conf/layout.xml";
      var vxml:XML = BBB.initConfigManager().config.layout;
      if (vxml.@layoutConfig != undefined) {
        layoutUrl = vxml.@layoutConfig.toString();
      }
            
      LogUtil.debug("LayoutManager: loading server layouts from " + layoutUrl);
      var loader:LayoutLoader = new LayoutLoader();
      loader.addEventListener(LayoutsLoadedEvent.LAYOUTS_LOADED_EVENT,onLayoutLoadedHandler);
      loader.loadFromUrl(layoutUrl);
    }
    
    private function onLayoutLoadedHandler(event:LayoutsLoadedEvent):void {
      if (event.success) {
//        _layouts = e.layouts;
        LogUtil.debug("LayoutManager: layouts loaded successfully");
      } else {
        LogUtil.error("LayoutManager: layouts not loaded (" + event.error.message + ")");
      }      
    }   
  }
}