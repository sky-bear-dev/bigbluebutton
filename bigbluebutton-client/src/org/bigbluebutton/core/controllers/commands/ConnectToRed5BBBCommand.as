package org.bigbluebutton.core.controllers.commands
{
    import org.bigbluebutton.core.model.imp.ConfigModel;
    import org.bigbluebutton.core.model.imp.UsersModel;
    import org.bigbluebutton.core.services.imp.Red5BBBAppConnectionService;
    import org.bigbluebutton.core.vo.ConnectParameters;
    import org.robotlegs.mvcs.Command;
    
    public class ConnectToRed5BBBCommand extends Command
    {
        [Inject]
        public var config:ConfigModel;
        
        [Inject]
        public var users:UsersModel;
        
        [Inject]
        public var service:Red5BBBAppConnectionService;
        
        override public function execute():void
        {
            var params:ConnectParameters = new ConnectParameters();
            params.conference = users.loggedInUser.conference;
            params.uri = config.applicationURI;
            params.externUserID = users.loggedInUser.externUserID;
            params.internalUserID = users.loggedInUser.internalUserID;
            params.room = users.loggedInUser.room;
            params.username = users.loggedInUser.username;
            params.role = users.loggedInUser.role;
            params.record = users.loggedInUser.record;
            params.voicebridge = users.loggedInUser.voicebridge;
            
            service.connect(params);                
        }
    }
}