package org.bigbluebutton.core.layout.model
{
  import mx.collections.ArrayList;
  
  import org.bigbluebutton.common.LogUtil;

  public class LayoutModel
  {
    private var _layouts:LayoutDefinitionFile;
    
    private var _currentLayout:LayoutDefinition;
    
    public function set layouts(l:LayoutDefinitionFile):void {
      _layouts = l;
    }
    
    public function getDefaultLayout():LayoutDefinition {
      return _layouts.getDefault();
    }
    
    public function setCurrentLayout(id:String):void {
      // TODO: Find layout based on ID
    }
    
    public function getCurrentLayout():LayoutDefinition {
      return _currentLayout;
    }
  }
}