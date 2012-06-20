package org.bigbluebutton.core.model.imp
{
    import org.bigbluebutton.core.controllers.events.UserAuthenticatedEvent;
    import org.bigbluebutton.core.model.vo.UserSession;
    import org.robotlegs.mvcs.Actor;

    public class UsersModel extends Actor
    {
       private var _loggedInUser:UserSession;
       
       public function set loggedInUser(user:UserSession):void {
           _loggedInUser = user;
           var event:UserAuthenticatedEvent = new UserAuthenticatedEvent();
           dispatch(event);
       }
        
    }
}