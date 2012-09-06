package org.bigbluebutton.main.views.model.vos
{
  public class MainApplicationShellModel
  {
    
    [Bindable]
    public var curState:String = "LoadingState";
        
    public function switchToJoinedState():void {
      curState = "JoinedState";
    }
  }
}