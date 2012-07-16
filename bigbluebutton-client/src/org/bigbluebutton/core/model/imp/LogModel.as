package org.bigbluebutton.core.model.imp
{
    import mx.logging.ILogger;
    import mx.logging.Log;
    import mx.logging.LogEventLevel;
    import org.bigbluebutton.core.Logger;
    import org.bigbluebutton.util.logging.ArrayCollectionLogTarget;
    
    public class LogModel implements Logger
    {
        private var logMsgs:ArrayCollectionLogTarget = new ArrayCollectionLogTarget();
        
        public function LogModel() {
            logMsgs.filters = ["*"];
            logMsgs.level = LogEventLevel.ALL;
            logMsgs.includeTime = true;
            logMsgs.includeDate = true;
            logMsgs.includeLevel = true;
        }
        
        public static const LOGGER:String = "BBBLOGGER";
          
        public function debug(message:String):void
        {
            logger.debug(message);
        }
        
        public function info(message:String):void
        {
            logger.info(message);
        }
        
        public function error(message:String):void
        {
            logger.error(message);
        }
        
        public function fatal(message:String):void
        {
            logger.fatal(message);
        }
        
        public function warn(message:String):void
        {
            logger.warn(message);
        }
               
        public function enableLogging(enabled:Boolean):void {
            if (enabled) {
                Log.addTarget(logMsgs);
            } else {
                Log.removeTarget(logMsgs);
            }
        }
        
        public function changeFilterTarget(newFilters:Array):void {
            Log.removeTarget(logMsgs);
            logMsgs.filters = newFilters;
            if (logMsgs.filters == null) 
                logMsgs.filters = ["*"];
            Log.addTarget(logMsgs);
        }
        
        public function get messages():String {
            return logMsgs.messages;
        }
        
        private function get logger():ILogger {
            return Log.getLogger(LOGGER);
        }
    }
}