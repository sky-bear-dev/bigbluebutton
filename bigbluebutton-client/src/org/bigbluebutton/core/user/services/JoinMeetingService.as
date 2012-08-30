package org.bigbluebutton.core.user.services
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.net.URLRequestMethod;
  import flash.net.URLVariables;
  
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.core.config.model.ConfigModel;
  import org.bigbluebutton.core.user.model.MeetingModel;
  import org.bigbluebutton.core.user.model.UsersModel;
  import org.bigbluebutton.core.user.model.vo.Meeting;

  public class JoinMeetingService
  {
    public var configModel:ConfigModel;
    public var usersModel:UsersModel;
    public var dispatcher:IEventDispatcher;
    public var meetingModel:MeetingModel;
    
    private var urlLoader:URLLoader = new URLLoader();
    private var request:URLRequest = new URLRequest();
    private var vars:URLVariables = new URLVariables();
    
    public function load():void
    {
      var date:Date = new Date();
      var url:String = configModel.config.application.host;
      
      LogUtil.debug("JoinMeetingService:load(...) " + url);
      request = new URLRequest(url);
      request.method = URLRequestMethod.GET;		
      
      urlLoader.addEventListener(Event.COMPLETE, handleComplete);	
      urlLoader.load(request);	
    }
    
    private function handleComplete(e:Event):void {			
      var xml:XML = new XML(e.target.data)
      
      var returncode:String = xml.returncode;
      if (returncode == 'FAILED') {
        LogUtil.debug("Join FAILED = " + xml);
        
//        navigateToURL(new URLRequest(xml.logoutURL),'_self')
        
      } else if (returncode == 'SUCCESS') {
        LogUtil.debug("Join SUCESS = " + xml);
        
        var meeting:Meeting = new Meeting();
        meeting.username = xml.fullname;
        meeting.name = xml.confname;
        meeting.id = xml.meetingID;
        meeting.externUserID = xml.externUserID;
        meeting.internalUserID = xml.internalUserID;
        meeting.role = xml.role;
        meeting.authToken = xml.room;
        meeting.record = Boolean(xml.record);
        meeting.webVoiceConf = xml.webvoiceconf;
        meeting.voiceBridge = xml.voicebridge;
        meeting.welcome = xml.welcome;
        meeting.logoutURL = xml.logoutUrl;
        
        meetingModel.meeting = meeting;
      }
      
    }
  }
}