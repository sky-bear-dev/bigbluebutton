package org.bigbluebutton.modules.present
{
    import flash.display.DisplayObjectContainer;
    import flash.system.ApplicationDomain;
    
    import org.bigbluebutton.core.BigBlueButtonModule;
    import org.robotlegs.core.IInjector;
    
    public class PresentationModule extends BigBlueButtonModule
    {
        public function PresentationModule(contextView:DisplayObjectContainer=null, autoStartup:Boolean=true, parentInjector:IInjector=null, applicationDomain:ApplicationDomain=null)
        {
            super(contextView, autoStartup, parentInjector, applicationDomain);
        }
        
        override public function set parentInjector(value:IInjector):void {
            
        }
        
        override public function dispose():void {
            
        }
    }
}