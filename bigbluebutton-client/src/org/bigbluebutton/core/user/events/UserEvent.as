package org.bigbluebutton.core.user.events
{
  import flash.events.Event;
  
  public class UserEvent extends Event
  {
    public static const USERS_ADDED:String = "all users has been queried and added";
    
    public function UserEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)
    {  
      super(type, bubbles, cancelable);
    }
  }
}