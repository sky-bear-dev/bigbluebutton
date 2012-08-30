package org.bigbluebutton.core.layout.model
{
  import mx.collections.ArrayList;
  
  import org.bigbluebutton.common.LogUtil;

  public class LayoutModel
  {
    // Injected by Mate Framework
    private var _layouts:ArrayList = new ArrayList();
    
    public function LayoutModel()
    {
      LogUtil.debug("*************************** Layout model inited. **********************");
    }
  }
}