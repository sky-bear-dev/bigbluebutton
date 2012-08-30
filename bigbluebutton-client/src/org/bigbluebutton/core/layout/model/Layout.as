package org.bigbluebutton.core.layout.model
{
  public class Layout
  {
    private var _id:String;
    private var _name:String;
    private var _role:String = "all";
    private var _config:XML;
    
    public function Layout(id:String, name:String, config:XML, role:String="all")
    {
      _id = id;
      _name = name;
      _role = role;
      _config = config;
    }
    
    public function id():String {
      return _id;
    }
    
    public function name():String {
      return _name;
    }
    
    public function role():String {
      return _role;
    }
    
    public function config():XML {
      return new XML(_config.toString());
    }    
  }
}