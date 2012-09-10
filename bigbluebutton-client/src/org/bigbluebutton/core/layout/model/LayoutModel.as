package org.bigbluebutton.core.layout.model
{
  import mx.collections.ArrayList;
  
  import org.bigbluebutton.common.LogUtil;

  public class LayoutModel
  {
    private var _layouts:LayoutDefinitionFile;
    
    public function set layouts(l:LayoutDefinitionFile):void {
      _layouts = l;
    }
    
    public function getDefaultLayout():LayoutDefinition {
      return _layouts.getDefault();
    }
  }
}