package org.bigbluebutton.core.controllers.commands
{
    import org.bigbluebutton.core.services.imp.JoinService;
    import org.robotlegs.mvcs.Command;
    
    public class JoinUserCommand extends Command
    {
        [Inject]
        public var service:JoinService;
        
        override public function execute():void
        {
            service.join();
        }
    }
}