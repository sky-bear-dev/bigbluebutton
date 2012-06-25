package org.bigbluebutton.modules.present.views
{
    import mx.controls.Alert;
    
    import org.bigbluebutton.core.Logger;
    import org.robotlegs.utilities.modular.mvcs.ModuleMediator;
    
    public class PresentationModuleShellMediator extends ModuleMediator
    {
 //       [Inject] 
 //       public var logger:Logger;
        
        override public function onRegister():void
        {
 //           logger.debug("onRegister PresentationModuleShellMediator");
            Alert.show("PresentationModuleShellMediator");
        }
    }
}