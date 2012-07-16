package org.bigbluebutton.core.model.imp
{
    import org.bigbluebutton.core.model.ILocale;
    import org.bigbluebutton.core.model.ILocaleModel;

    public class LocaleModel implements ILocaleModel
    {
        private var resourceManager:IResourceManager;
        
        public function LocaleModel()
        {
        }
        
        [Bindable("change")]
        function getString(resourceName:String, parameters:Array = null, locale:String = null):String {
            /**
             * Get the translated string from the current locale. If empty, get the string from the master
             * locale. Locale chaining isn't working because mygengo actually puts the key and empty value
             * for untranslated strings into the locale file. So, when Flash does a lookup, it will see that
             * the key is available in the locale and thus not bother falling back to the master locale.
             *    (ralam dec 15, 2011).
             */
            var localeTxt:String = resourceManager.getString(BBB_RESOURCE_BUNDLE, resourceName, parameters, null);
            if ((localeTxt == "") || (localeTxt == null)) {
                localeTxt = resourceManager.getString(BBB_RESOURCE_BUNDLE, resourceName, parameters, MASTER_LOCALE);
            }
            return localeTxt;
        }
    }
}