package org.bigbluebutton.main.views.model.vos
{
  import flash.sampler.getLexicalScopes;
  
  import org.bigbluebutton.util.i18n.ResourceUtil;

  public class MainToolbarModel
  {
    [Bindable]
    public var shortcutBtnLabel:String = ResourceUtil.getInstance().getString('bbb.mainToolbar.shortcutBtn');
    
    [Bindable]
    public var shortcutBtnTooltip:String = ResourceUtil.getInstance().getString('bbb.mainToolbar.shortcutBtn.toolTip');
    
    [Bindable]
    public var helpBtnLabel:String = ResourceUtil.getInstance().getString('bbb.mainToolbar.helpBtn');
    
    [Bindable]
    public var logoutBtnLabel:String = ResourceUtil.getInstance().getString('bbb.mainToolbar.logoutBtn');
    
    [Bindable]
    public var logoutBtnTooltip:String = ResourceUtil.getInstance().getString('bbb.mainToolbar.logoutBtn.toolTip');
    
    [Bindable]
    public var showToolbar:Boolean = false;
    
    [Bindable]
    public var showLangSelector:Boolean = false;

    [Bindable]
    public var showHelpBtn:Boolean = false;
    
    
  }
}