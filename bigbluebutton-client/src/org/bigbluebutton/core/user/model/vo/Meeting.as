package org.bigbluebutton.core.user.model.vo
{
  public class Meeting
  {
    
    public var username:String;
    public var name:String;
    public var id:String;
    public var externUserID:String;
    public var internalUserID:String;
    public var role:String;
    public var authToken:String;
    public var record:Boolean;
    public var webVoiceConf:String;
    public var voiceBridge:String;
    public var welcome:String;
    public var logoutURL:String;
    
    public function Meeting()
    {
    }
  }
}