package org.bigbluebutton.core.services.imp
{
    import flash.events.AsyncErrorEvent;
    import flash.events.IOErrorEvent;
    import flash.events.NetStatusEvent;
    import flash.events.SecurityErrorEvent;
    import flash.events.TimerEvent;
    import flash.net.NetConnection;
    import flash.net.Responder;
    import flash.utils.Timer;
    
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.core.controllers.events.ConnectedToRed5Event;
    import org.bigbluebutton.core.controllers.events.ConnectionEvent;
    import org.bigbluebutton.core.controllers.events.ConnectionFailedEvent;
    import org.bigbluebutton.core.controllers.events.UsersConnectionEvent;
    import org.bigbluebutton.core.model.imp.MeetingModel;
    import org.bigbluebutton.core.model.vo.User;
    import org.bigbluebutton.core.vo.ConnectParameters;
    import org.robotlegs.mvcs.Actor;

    public class Red5BBBAppConnectionService extends Actor
    {
        [Inject]
        public var logger:Logger;

        [Inject]
        public var meetingModel:MeetingModel;
        
        private var _netConnection:NetConnection;	        
        private var _connectParams:ConnectParameters;
                       
        public function get connection():NetConnection {
            return _netConnection;
        }
        

        public function connect(params:ConnectParameters):void
        {	
            _connectParams = params;
            connectToRed5();	
        }
        
        private var rtmpTimer:Timer = null;
        private const ConnectionTimeout:int = 5000;
        
        private function connectToRed5(rtmpt:Boolean=false):void
        {
            var uri:String = _connectParams.uri + "/" + _connectParams.room;
            
            _netConnection = new NetConnection();
            _netConnection.client = this;
            _netConnection.addEventListener(NetStatusEvent.NET_STATUS, connectionHandler);
            _netConnection.addEventListener(AsyncErrorEvent.ASYNC_ERROR, netASyncError);
            _netConnection.addEventListener(SecurityErrorEvent.SECURITY_ERROR, netSecurityError);
            _netConnection.addEventListener(IOErrorEvent.IO_ERROR, netIOError);
            uri = (rtmpt ? "rtmpt:" : "rtmp:") + "//" + uri
            logger.debug("Connect to " + uri);
            _netConnection.connect(uri, _connectParams.username, _connectParams.role, _connectParams.conference, 
                _connectParams.room, _connectParams.voicebridge, _connectParams.record, _connectParams.externUserID, _connectParams.internalUserID);
            if (!rtmpt) {
                rtmpTimer = new Timer(ConnectionTimeout, 1);
                rtmpTimer.addEventListener(TimerEvent.TIMER_COMPLETE, rtmpTimeoutHandler);
                rtmpTimer.start();
            }
        }
        
        private function rtmpTimeoutHandler(e:TimerEvent):void
        {
            _netConnection.close();
            _netConnection = null;
            
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
                
        public function getMyUserID():void {
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
                        dispatch(e);
                    },	
                    // status - On error occurred
                    function(status:Object):void { 
                        logger.error("getMyUserID Error occurred:"); 
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
                    dispatch(new ConnectedToRed5Event());                   
                    break;
                
                case "NetConnection.Connect.Failed":					
                    dispatch(new ConnectionEvent(ConnectionEvent.CONNECTION_FAILED));								
                    break;
                
                case "NetConnection.Connect.Closed":				
                    dispatch(new ConnectionEvent(ConnectionEvent.CONNECTION_CLOSED));								
                    break;
                
                case "NetConnection.Connect.InvalidApp":			
                    dispatch(new ConnectionEvent(ConnectionEvent.INVALID_APP));				
                    break;
                
                case "NetConnection.Connect.AppShutDown":
                    dispatch(new ConnectionEvent(ConnectionEvent.APP_SHUTDOWN));	
                    break;
                
                case "NetConnection.Connect.Rejected":
                    dispatch(new ConnectionEvent(ConnectionEvent.CONNECTION_REJECTED));		
                    break;
                
                case "NetConnection.Connect.NetworkChange":
                    dispatch(new ConnectionEvent(ConnectionEvent.CONNECTION_NETWORK_CHANGE_EVENT));
                    break;
                
                default:                
                    dispatch(new ConnectionEvent(ConnectionEvent.UNKNOWN_REASON));
                    break;
            }
        }
        
        protected function netSecurityError(event:SecurityErrorEvent):void 
        {
            dispatch(new ConnectionEvent(ConnectionEvent.UNKNOWN_REASON));
        }
        
        protected function netIOError(event:IOErrorEvent):void 
        {
            logger.debug("Input/output error - " + event.text);
            dispatch(new ConnectionEvent(ConnectionEvent.UNKNOWN_REASON));
        }
        
        protected function netASyncError(event:AsyncErrorEvent):void 
        {
            logger.debug("Asynchronous code error - " + event.error);
            dispatch(new ConnectionEvent(ConnectionEvent.UNKNOWN_REASON));
        }	
        
        /**
         *  Callback from server
         */
        public function setUserId(id:Number, role:String):String
        {
            logger.debug( "ViewersNetDelegate::setConnectionId: id=[" + id + "," + role + "]");
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