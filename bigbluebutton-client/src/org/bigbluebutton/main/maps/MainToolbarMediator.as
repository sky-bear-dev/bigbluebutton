package org.bigbluebutton.main.maps
{
  import flash.events.IEventDispatcher;
  
  import mx.controls.Button;
  import mx.core.UIComponent;
  
  import org.bigbluebutton.common.IBbbToolbarComponent;
  import org.bigbluebutton.common.events.ToolbarButtonEvent;
  import org.bigbluebutton.main.views.MainToolbar;
  import org.bigbluebutton.main.views.model.vos.MainToolbarModel;

  public class MainToolbarMediator
  {
    public var model:MainToolbarModel;
    public var view:MainToolbar;
    public var dispatcher:IEventDispatcher;
    
    public function MainToolbarMediator()
    {
    }
    
    public function displayToolbar():void {
      toolbarOptions = new LayoutOptions();
      toolbarOptions.parseOptions();	
      if (toolbarOptions.showToolbar) {
        showToolbar = true;
      } else {
        showToolbar = false;
      }
      
      if (toolbarOptions.showHelpButton) {
        showHelpBtn = true;
      } else {
        showHelpBtn = false;
      }
    }
    
    public function addButton(name:String):Button {
      var btn:Button = new Button();
      btn.id = name;
      btn.label = name;
      btn.height = 20;
      btn.visible = true;
      view.addChild(btn);
      
      return btn;
    }
    
//    private function onHelpButtonClicked():void {
//      navigateToURL(new URLRequest(DEFAULT_HELP_URL))
//    }
    
    private function handleEndMeetingEvent(event:BBBEvent):void {
      LogUtil.debug("Received end meeting event.");
      doLogout();
    }
    
    private function doLogout():void {
      dispatchEvent(new LogoutEvent(LogoutEvent.USER_LOGGED_OUT));
    }
    
    private function hideToolbar(e:ConnectionFailedEvent):void{
      if (toolbarOptions.showToolbar) {
        view.visible = false;
      } else {
        view.visible = true;
      }
    }
    
    private function handleAddToolbarButtonEvent(event:ToolbarButtonEvent):void {
      if (event.location == ToolbarButtonEvent.TOP_TOOLBAR) {
        view.addedBtns.addChild(event.button as UIComponent);
        realignButtons();
      }
    }
    
    private function handleRemoveToolbarButtonEvent(event:ToolbarButtonEvent):void {
      if (view.addedBtns.contains(event.button as UIComponent))
        view.addedBtns.removeChild(event.button as UIComponent);
    }
    
    private function realignButtons():void{
      for each (var button:UIComponent in view.addedBtns.getChildren()){
        var toolbarComponent:IBbbToolbarComponent = button as IBbbToolbarComponent;
        if (toolbarComponent.getAlignment() == ALIGN_LEFT) view.addedBtns.setChildIndex(button, 0);
        else if (toolbarComponent.getAlignment() == ALIGN_RIGHT) view.addedBtns.setChildIndex(button, view.addedBtns.numChildren - 1);
      }
    }
    
    private function gotConfigParameters(e:ConfigEvent):void{
      langSelector.visible = e.config.languageEnabled;
      DEFAULT_HELP_URL = e.config.helpURL;
    }
    
    private function onDisconnectTest():void{
      var d:Dispatcher = new Dispatcher();
      var e:LogoutEvent = new LogoutEvent(LogoutEvent.DISCONNECT_TEST);
      d.dispatchEvent(e);
    }
    
    private function showSettingsButton(e:SettingsEvent):void{
      var b:Button = new Button();
      b.label = ResourceUtil.getInstance().getString('bbb.mainToolbar.settingsBtn');
      b.toolTip = ResourceUtil.getInstance().getString('bbb.mainToolbar.settingsBtn.toolTip');
      b.addEventListener(MouseEvent.CLICK, openSettings);
      this.addChild(b);
    }
    
    private function openSettings(e:Event = null):void{
      var d:Dispatcher = new Dispatcher();
      d.dispatchEvent(new SettingsEvent(SettingsEvent.OPEN_SETTINGS_PANEL));
    }
    
    private function onShortcutButtonClick(e:Event = null):void {
      var d:Dispatcher = new Dispatcher();
      d.dispatchEvent(new ShortcutEvent(ShortcutEvent.OPEN_SHORTCUT_WIN));
    }
  }
}