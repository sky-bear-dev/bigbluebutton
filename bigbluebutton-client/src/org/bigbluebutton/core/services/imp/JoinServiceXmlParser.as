package org.bigbluebutton.core.services.imp
{
    import org.bigbluebutton.core.controllers.events.FailedToJoinEvent;
    import org.bigbluebutton.core.model.imp.UsersModel;
    import org.bigbluebutton.core.model.vo.UserSession;
    import org.robotlegs.mvcs.Actor;

    public class JoinServiceXmlParser extends Actor
    {
        [Inject]
        public var usersModel:UsersModel;
        
        public function parseJoinServiceResult(xml:XML):void {
            var returncode:String = xml.returncode;
            if (returncode == 'FAILED') {
                var event:FailedToJoinEvent = new FailedToJoinEvent();
                event.logoutURL = xml.logoutURL;
                dispatch(event);                
            } else if (returncode == 'SUCCESS') {                
                var user:UserSession = new UserSession();                     
                user.username = xml.fullname;
                user.conference = xml.conference;
                user.conferenceName = xml.confname;
                user.meetingID = xml.meetingID;
                user.externUserID = xml.externUserID;
                user.internalUserID = xml.internalUserId;
                user.role = xml.role;
                user.room = xml.room;
                user.authToken = xml.room;
                user.record = xml.record as Boolean;
                user.webvoiceconf = xml.webvoiceconf;
                user.voicebridge = xml.voicebridge;
                user.mode = xml.mode;
                user.welcome = xml.welcome;
                user.logoutUrl = xml.logoutUrl;
                
                usersModel.loggedInUser = user;
            }           
        }

    }
}