# Event planning API

[Documentation for API endpoints](https://event-planning-api.herokuapp.com)

Management system for planning events (REST API)

### Capabilities
- token based authentication with email or github account;
- create an event(event could be created only in future, maximun length of
 description is 500 chars);
- update and delete own events;
- read event, if current_user is participant (invited to event or organizer);
- get future/past events (GET "/api/events?time=past");
- get closest events (GET "/api/events?due={timestamp}" or 
GET "/api/events?interval=2d");
- invite other users to the event (for participants only);
- create attachments with files to event (for participants only);
- create comments to event (for participants only);
- get activity feed (latest changes of events, where current_user is participant; 
new comments, file attachments and invitations to this events).