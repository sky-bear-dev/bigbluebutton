package org.bigbluebutton.modules.present.views
{
    import flash.display.Sprite;
    
    import mx.core.UIComponent;
    
    import org.bigbluebutton.modules.present.PresentModuleContext;
    import org.robotlegs.mvcs.Context;

    public class PresentationModule extends UIComponent
    {
        public var context:Context
        
        public function PresentationModule()
        {
            context = new PresentModuleContext(this);    
        }
        
        
    }
}