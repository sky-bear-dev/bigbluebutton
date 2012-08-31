/**
 * BigBlueButton open source conferencing system - http://www.bigbluebutton.org/
 *
 * Copyright (c) 2010 BigBlueButton Inc. and by respective authors (see below).
 *
 * This program is free software; you can redistribute it and/or modify it under the
 * terms of the GNU Lesser General Public License as published by the Free Software
 * Foundation; either version 2.1 of the License, or (at your option) any later
 * version.
 *
 * BigBlueButton is distributed in the hope that it will be useful, but WITHOUT ANY
 * WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
 * PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public License along
 * with BigBlueButton; if not, see <http://www.gnu.org/licenses/>.
 * 
 */
package org.bigbluebutton.core.modules.model
{
  import flash.events.Event;
  import flash.events.IEventDispatcher;
  import flash.events.ProgressEvent;
  import flash.utils.Dictionary; 
  import mx.collections.ArrayCollection;
  import mx.core.IFlexModuleFactory;
  import mx.events.ModuleEvent;
  import mx.modules.ModuleLoader;
  import mx.utils.StringUtil;  
  import org.bigbluebutton.common.IBigBlueButtonModule;
  import org.bigbluebutton.common.LogUtil;
  import org.bigbluebutton.core.modules.events.ModuleLoadEvent;
  import org.bigbluebutton.main.model.ConferenceParameters;
  
  public class ModuleDescriptor
  {
    private var _attributes:Object;
    private var _loader:ModuleLoader;
    private var _module:IBigBlueButtonModule;
    private var _loaded:Boolean = false;
    private var _connected:Boolean = false;
    
    public var unresolvedDependancies:ArrayCollection;
    public var resolved:Boolean = false;
    public var dispatcher:IEventDispatcher;
    
    
    public function ModuleDescriptor(attributes:XML)
    {
      unresolvedDependancies = new ArrayCollection();
      _attributes = new Object();
      _loader = new ModuleLoader();
      
      parseAttributes(attributes);			
    }
       
    public function addAttribute(attribute:String, value:Object):void {
      _attributes[attribute] = value;
    }
    
    public function getName():String{
      return _attributes["name"] as String;
    }
    
    public function getAttribute(name:String):Object {
      return _attributes[name];
    }
    
    public function get attributes():Object {
      return _attributes;
    }
    
    public function get module():IBigBlueButtonModule {
      return _module;
    }
    
    public function get loaded():Boolean {
      return _loaded;
    }
    
    public function get loader():ModuleLoader{
      return _loader;
    }
    
    private function parseAttributes(item:XML):void {
      var attNamesList:XMLList = item.@*;
      
      for (var i:int = 0; i < attNamesList.length(); i++)
      { 
        var attName:String = attNamesList[i].name();
        var attValue:String = item.attribute(attName);
        _attributes[attName] = attValue;
      }
      
      populateDependancies();
    }
       
    public function load():void {
      _loader.addEventListener("loading", onLoading);
      _loader.addEventListener("progress", onLoadProgress);
      _loader.addEventListener("ready", onReady);
      _loader.addEventListener("error", onErrorLoading);
      _loader.url = _attributes.url;
      LogUtil.debug("Loading " + _attributes.url);
      _loader.loadModule();
    }
    
    private function onReady(event:Event):void {
      LogUtil.debug(getName() + "finished loading");
      
      var modLoader:ModuleLoader = event.target as ModuleLoader;
      
      if (!(modLoader.child is IBigBlueButtonModule)) {
        throw new Error(getName() + " is not a valid BigBlueButton module");
      }
      
      _module = modLoader.child as IBigBlueButtonModule;
      
      if (_module != null) {
        _loaded = true;
        var moduleEvent:ModuleLoadEvent = new ModuleLoadEvent(ModuleLoadEvent.MODULE_LOAD_SUCCESS);
        moduleEvent.moduleName = getName();
        dispatcher.dispatchEvent(moduleEvent);
      } else {
        LogUtil.error("Module loaded is null.");
      }     
    }	
    
    private function onLoadProgress(e:ProgressEvent):void {
      LogUtil.debug(getName() + " still loading");
      var moduleEvent:ModuleLoadEvent = new ModuleLoadEvent(ModuleLoadEvent.MODULE_LOAD_PROGRESS);
      moduleEvent.moduleName = getName();
      moduleEvent.percentLoaded = Math.round((e.bytesLoaded/e.bytesTotal) * 100);
      dispatcher.dispatchEvent(moduleEvent);
    }	
    
    private function onErrorLoading(e:ModuleEvent):void{
      LogUtil.error("Error loading " + getName() + e.errorText);
      var moduleEvent:ModuleLoadEvent = new ModuleLoadEvent(ModuleLoadEvent.MODULE_LOAD_ERROR);
      moduleEvent.moduleName = getName();
      dispatcher.dispatchEvent(moduleEvent);
    }
    
    private function onLoading(e:Event):void {
      LogUtil.debug(getName() + " is loading");
      var moduleEvent:ModuleLoadEvent = new ModuleLoadEvent(ModuleLoadEvent.MODULE_LOAD_START);
      moduleEvent.moduleName = getName();
      dispatcher.dispatchEvent(moduleEvent);
    }
       
    public function removeDependancy(module:String):void{
      for (var i:int = 0; i<unresolvedDependancies.length; i++){
        if (unresolvedDependancies[i] == module) unresolvedDependancies.removeItemAt(i);
      }
    }
    
    private function populateDependancies():void{
      var dependString:String = _attributes["dependsOn"] as String;
      if (dependString == null) return;
      
      var trimmedString:String = StringUtil.trimArrayElements(dependString, ",");
      var dependancies:Array = trimmedString.split(",");
      
      for (var i:int = 0; i < dependancies.length; i++){
        unresolvedDependancies.addItem(dependancies[i]);
      }
    }
    
  }
}