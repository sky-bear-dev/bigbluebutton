package org.bigbluebutton.core.model.imp
{
	import org.bigbluebutton.core.Utils;

    public class LocaleModel
    {
        private static var MASTER_LOCALE:String = "en_US";
        
        private var _localeCodes:Array;
        private var _localeNames:Array;
        
		public function get localCodes():Array {
			return _localCodes;
		}
		
		public function get localNames():Array {
			return _localNames;
		}
		
		public function set localCodes(codes: Array):void {
			_localCodes = Utils.clone(codes);
		}
		
		public function set localNames(names: Array):void {
			_localNames = Utils.clone(names);
		}
		
        public function LocaleModel()
        {
        }
    }
}