package org.bigbluebutton.modules.present.views
{
    import mx.controls.Alert;
    
    import org.bigbluebutton.core.Logger;
    import org.robotlegs.mvcs.Mediator;
    
    public class PresentationModuleShellMediator extends Mediator
    {
        [Inject] 
        public var logger:Logger;
        
        override public function onRegister():void
        {
           logger.debug("onRegister PresentationModuleShellMediator");
 //           Alert.show("PresentationModuleShellMediator");
        }
    }
}