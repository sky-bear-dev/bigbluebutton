package org.bigbluebutton.main.views.model.vos
{
  import org.bigbluebutton.common.Images;
  import org.bigbluebutton.util.i18n.ResourceUtil;

  public class MainFooterBarModel
  {
    private var images:Images = new Images();
    
    [Bindable]
    public var copyrightLabel:String = ResourceUtil.getInstance().getString('bbb.mainshell.copyrightLabel2');
    
    [Bindable]
    public var logBtnTooltip:String = ResourceUtil.getInstance().getString('bbb.mainshell.logBtn.toolTip');
    
    [Bindable]
    public var showLogButton:Boolean = true;
    
    [Bindable]
    public var logsIcon:Class = images.table;
  }
}