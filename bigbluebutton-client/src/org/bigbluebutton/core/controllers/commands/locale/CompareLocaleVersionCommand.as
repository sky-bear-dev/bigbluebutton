package org.bigbluebutton.core.controllers.commands.locale
{
	import org.bigbluebutton.core.Logger;
	import org.bigbluebutton.core.controllers.events.config.ConfigVersionEvent;
	import org.bigbluebutton.core.model.imp.ConfigModel;
	import org.bigbluebutton.core.model.imp.LocaleModel;
	import org.robotlegs.mvcs.Command;
	
	public class CompareLocaleVersionCommand extends Command
	{
		[Inject]
		public var configModel:ConfigModel;
		
		[Inject]
		public var localeModel:LocaleModel;
		
        [Inject]
        public var logger:Logger;
        
		override public function execute():void
		{   
            logger.debug(configModel.localeVersion + " == " + localeModel.localeVersion + "(" + configModel.version + ")");
            
			if (configModel.localeVersion == localeModel.localeVersion) {
                logger.debug(ConfigVersionEvent.CONFIG_VERSION_SAME_EVENT);
				dispatch(new ConfigVersionEvent(ConfigVersionEvent.CONFIG_VERSION_SAME_EVENT));
			} else {
                logger.debug(ConfigVersionEvent.CONFIG_VERSION_NOT_SAME_EVENT);
				dispatch(new ConfigVersionEvent(ConfigVersionEvent.CONFIG_VERSION_NOT_SAME_EVENT));
			}
		}
	}
}