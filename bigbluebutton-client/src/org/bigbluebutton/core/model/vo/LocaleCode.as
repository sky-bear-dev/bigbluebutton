package org.bigbluebutton.core.model.vo
{
    public class LocaleCode
    {
        private var _code: String;
        private var _name: String;
        
        public function LocaleCode(code: String, name: String)
        {
            _code = code;
            _name = name;
        }
        
        public function get code():String 
        {
            return _code;    
        }
        
        public function get name():String {
            return _name;
        }
            
    }
}