package org.bigbluebutton.core.controllers.commands
{
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.core.services.imp.UsersService;
    import org.robotlegs.mvcs.Command;
    
    public class ListenForUserMessagesCommand extends Command
    {
        [Inject]
        public var logger:Logger;
        
        [Inject]
        public var service:UsersService;
        
        override public function execute():void
        {
            logger.debug("Listen for user messages");
            service.listenForUserMessages();
        }
    }
}