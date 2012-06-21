package org.bigbluebutton.core.controllers.commands
{
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.core.services.imp.Red5BBBAppConnectionService;
    import org.robotlegs.mvcs.Command;
    
    public class GetMyUserIdCommand extends Command
    {
        [Inject]
        public var service:Red5BBBAppConnectionService;
        
        [Inject]
        public var logger:Logger;
        
        override public function execute():void
        {
            logger.debug("Getting my user id");
            service.getMyUserID();
        }
    }
}