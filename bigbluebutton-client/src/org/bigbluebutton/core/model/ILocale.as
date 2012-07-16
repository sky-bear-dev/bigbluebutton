package org.bigbluebutton.core.model
{
    public interface ILocale
    {
        [Bindable("change")]
        function getString(resourceName:String, parameters:Array = null, locale:String = null):String;
    }
}