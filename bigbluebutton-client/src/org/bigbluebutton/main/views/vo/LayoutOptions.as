package org.bigbluebutton.main.views.vo
{
    public class LayoutOptions
    {
        [Bindable] public var showDebugWindow:Boolean = true;
        [Bindable] public var showLogButton:Boolean = true;
        [Bindable] public var showVideoLayout:Boolean = true;
        [Bindable] public var showResetLayout:Boolean = true;
        [Bindable] public var showToolbar:Boolean = true;
        [Bindable] public var showHelpButton:Boolean = true;
        [Bindable] public var showLogoutWindow:Boolean = true;
        
        public function LayoutOptions(layout:XML)
        {
            if (layout != null) {
                if (layout.@showDebugWindow != undefined) {
                    showDebugWindow = (layout.@showDebugWindow.toString().toUpperCase() == "TRUE") ? true : false;
                }
                
                if (layout.@showLogButton != undefined) {
                    showLogButton = (layout.@showLogButton.toString().toUpperCase() == "TRUE") ? true : false;
                }
                
                if (layout.@showVideoLayout != undefined) {
                    showVideoLayout = (layout.@showVideoLayout.toString().toUpperCase() == "TRUE") ? true : false;
                }
                
                if (layout.@showResetLayout != undefined) {
                    showResetLayout = (layout.@showResetLayout.toString().toUpperCase() == "TRUE") ? true : false;
                }
                
                if (layout.@showToolbar != undefined) {
                    showToolbar = (layout.@showToolbar.toString().toUpperCase() == "TRUE") ? true : false;
                }
                
                if (layout.@showHelpButton != undefined) {
                    showHelpButton = (layout.@showHelpButton.toString().toUpperCase() == "TRUE") ? true : false;
                }
                
                if (layout.@showLogoutWindow != undefined) {
                    showLogoutWindow = (layout.@showLogoutWindow.toString().toUpperCase() == "TRUE") ? true : false;
                }
            }
        }
    }
}