package org.bigbluebutton.core
{
    public interface Logger
    {
        function debug(message:String):void;
        
        function info(message:String):void;
        
        function error(message:String):void;
        
        function fatal(message:String):void;
        
        function warn(message:String):void;  
        
        function enableLogging(enabled:Boolean):void;
        
        function get messages():String;
    }
}