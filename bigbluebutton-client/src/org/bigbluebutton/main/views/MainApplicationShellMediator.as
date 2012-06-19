package org.bigbluebutton.main.views
{
    import org.robotlegs.mvcs.Mediator;
    
    public class MainApplicationShellMediator extends Mediator
    {
        [Inject]
        public var view: MainApplicationShell;
        
        override public function onRegister():void
        {
//            addViewListener();
//            addContextListener();
            
 //           dispatch(new MainShellReadyEvent(MainShellReadyEvent.READY));
        }
    }
}