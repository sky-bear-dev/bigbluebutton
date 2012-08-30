package org.bigbluebutton.core.config.model
{
  import org.bigbluebutton.core.model.Config;

  public class ConfigModel
  {
    
    private var _config:Config;
    
    public function ConfigModel()
    {
    }
    
    public function set config(c:Config):void {
      _config = c;
    }
    
    public function get config():Config {
      return _config;
    }
  }
}