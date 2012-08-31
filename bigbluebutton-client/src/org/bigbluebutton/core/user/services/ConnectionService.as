package org.bigbluebutton.core.user.services
{
  import flash.events.AsyncErrorEvent;
  import flash.events.IEventDispatcher;
  import flash.events.IOErrorEvent;
  import flash.events.NetStatusEvent;
  import flash.events.SecurityErrorEvent;
  import flash.events.TimerEvent;
  import flash.net.NetConnection;
  import flash.net.Responder;
  import flash.utils.Timer;
  
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.core.config.model.ConfigModel;
  import org.bigbluebutton.core.user.events.ConnectionEvent;
  import org.bigbluebutton.core.user.model.MeetingModel;
  import org.bigbluebutton.core.user.model.UsersModel;
  import org.bigbluebutton.main.model.users.events.UsersConnectionEvent;
  
  public class ConnectionService
  {
    public var dispatcher:IEventDispatcher;
    public var meetingModel:MeetingModel;   
    public var configModel:ConfigModel; 
    public var usersModel:UsersModel;
    
    private var _netConnection:NetConnection = new NetConnection();	        
    private var _connUri:String;
    
    public function get connectionUri():String {
      return _connUri;
    }
    
    public function get connection():NetConnection {
      return _netConnection;
    }
    
    
    public function connect():void
    {	
      connectToRed5();	
    }
        
    private var rtmpTimer:Timer = null;
    private const ConnectionTimeout:int = 5000;
    
    private function connectToRed5(rtmpt:Boolean=false):void
    {
      var appOptions:Object = configModel.config.application;
      
      var uri:String = appOptions.server + "/" + appOptions.app + "/" + meetingModel.meeting.id;
      
      _netConnection.client = this;
      _netConnection.addEventListener(NetStatusEvent.NET_STATUS, connectionHandler);
      _netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, netASyncError);
      _netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, netSecurityError);
      _netConnection.addEventListener(IOErrorEvent.IO_ERROR, netIOError);
      
      if (appOptions.forceTunnel) rtmpt = true;
      
      _connUri = (rtmpt ? "rtmpt:" : "rtmp:") + "//" + uri
      
      try {	      
        var username:String = meetingModel.meeting.username;
        var meetingID:String = meetingModel.meeting.id;
        var externUserID:String = meetingModel.meeting.externUserID;
        var internalUserID:String = meetingModel.meeting.internalUserID;
        var role:String = meetingModel.meeting.role;
        var authToken:String = meetingModel.meeting.authToken;
        var record:Boolean = meetingModel.meeting.record;
        var webVoiceConf:String = meetingModel.meeting.webVoiceConf;
        var voiceBridge:String = meetingModel.meeting.voiceBridge;

        
        LogUtil.debug("Connecting to " + _connUri + " params[user=" + username + ",role=" + role 
                          + ",meetingid=" + meetingID + ",record=" + record + "]");	
        
        _netConnection.connect(_connUri, username, role, meetingID, meetingID, 
                                voiceBridge, record, externUserID, internalUserID);		
        
        if (!rtmpt) {
          rtmpTimer = new Timer(ConnectionTimeout, 1);
          rtmpTimer.addEventListener(TimerEvent.TIMER_COMPLETE, rtmpTimeoutHandler);
          rtmpTimer.start();
        }
      } catch(e:ArgumentError) {
        // Invalid parameters.
        switch (e.errorID) {
          case 2004 :						
            LogUtil.debug("Error! Invalid server location: " + _connUri);											   
            break;						
          default :
            LogUtil.debug("UNKNOWN Error! Invalid server location: " + _connUri);
            break;
        }
      }
    }
    
    private function rtmpTimeoutHandler(e:TimerEvent):void
    {
      LogUtil.debug("RTMP connection attempt timedout. Trying RTMPT.");
      _netConnection.close();
      _netConnection = new NetConnection();;
      
      connectToRed5(true);
    }
    
    private function connectionHandler(e:NetStatusEvent):void
    {
      if (rtmpTimer) {
        rtmpTimer.stop();
        rtmpTimer = null;
      }
      
      handleResult(e);
    }
    
    public function disconnect(logoutOnUserCommand:Boolean):void
    {
      _netConnection.close();
    }
    
    public function getMyUserIDReply():void {
      LogUtil.debug("Getting user id reply");
    }
    
    
    public function getMyUserID():void {
      LogUtil.debug("Getting user id");
      _netConnection.call(
        "getMyUserId",// Remote function name
        new Responder(
          // result - On successful result
          function(result:Object):void { 
            var useridString:String = result as String;
            meetingModel.myUserID = useridString;
            var e:UsersConnectionEvent = new UsersConnectionEvent(UsersConnectionEvent.CONNECTION_SUCCESS);
            e.connection = _netConnection;
            e.userid = useridString;
            dispatcher.dispatchEvent(e);
          },	
          // status - On error occurred
          function(status:Object):void { 
            LogUtil.error("getMyUserID Error occurred:"); 
          }
        )//new Responder
      ); //_netConnection.call            
    }
    
    public function handleResult(event:NetStatusEvent):void {
      var info:Object = event.info;
      var statusCode:String = info.code;
      
      switch (statusCode) 
      {
        case "NetConnection.Connect.Success":
          LogUtil.debug("NetConnection.Connect.Success");
          dispatcher.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_SUCCEED));	
          break;
        
        case "NetConnection.Connect.Failed":
          LogUtil.debug("NetConnection.Connect.Failed");
          dispatcher.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_FAILED));								
          break;
        
        case "NetConnection.Connect.Closed":	
          LogUtil.debug("NetConnection.Connect.Closed");
          dispatcher.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_CLOSED));								
          break;
        
        case "NetConnection.Connect.InvalidApp":	
          LogUtil.debug("NetConnection.Connect.InvalidApp");
          dispatcher.dispatchEvent(new ConnectionEvent(ConnectionEvent.INVALID_APP));				
          break;
        
        case "NetConnection.Connect.AppShutDown":
          LogUtil.debug("NetConnection.Connect.AppShutDown");
          dispatcher.dispatchEvent(new ConnectionEvent(ConnectionEvent.APP_SHUTDOWN));	
          break;
        
        case "NetConnection.Connect.Rejected":
          LogUtil.debug("NetConnection.Connect.Rejected");
          dispatcher.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_REJECTED));		
          break;
        
        case "NetConnection.Connect.NetworkChange":
          LogUtil.debug("NetConnection.Connect.NetworkChange");
          dispatcher.dispatchEvent(new ConnectionEvent(ConnectionEvent.CONNECTION_NETWORK_CHANGE_EVENT));
          break;
        
        default:       
          LogUtil.debug(ConnectionEvent.UNKNOWN_REASON);
          dispatcher.dispatchEvent(new ConnectionEvent(ConnectionEvent.UNKNOWN_REASON));
          break;
      }
    }
    
    protected function netSecurityError(event:SecurityErrorEvent):void 
    {
      dispatcher.dispatchEvent(new ConnectionEvent(ConnectionEvent.UNKNOWN_REASON));
    }
    
    protected function netIOError(event:IOErrorEvent):void 
    {
      LogUtil.debug("Input/output error - " + event.text);
      dispatcher.dispatchEvent(new ConnectionEvent(ConnectionEvent.UNKNOWN_REASON));
    }
    
    protected function netASyncError(event:AsyncErrorEvent):void 
    {
      LogUtil.debug("Asynchronous code error - " + event.error);
      dispatcher.dispatchEvent(new ConnectionEvent(ConnectionEvent.UNKNOWN_REASON));
    }	
    
    /**
     *  Callback from server
     */
    public function setUserId(id:Number, role:String):String
    {
      LogUtil.debug( "ViewersNetDelegate::setConnectionId: id=[" + id + "," + role + "]");
      if (isNaN(id)) return "FAILED";
      
      // We should be receiving authToken and room from the server here.
      //_userid = id;								
      return "OK";
    }
    
    public function onBWCheck(... rest):Number { 
      return 0; 
    } 
    
    public function onBWDone(... rest):void { 
      var p_bw:Number; 
      if (rest.length > 0) p_bw = rest[0]; 
      // your application should do something here 
      // when the bandwidth check is complete 
      trace("bandwidth = " + p_bw + " Kbps."); 
    }
  }
}