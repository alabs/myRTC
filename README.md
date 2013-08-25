myRTC
=====

Welcome to myRTC, a WebRTC Rooms Experiment written in Ruby On Rails, 
using the SimpleWebRTC library. 

Install
======

To develop on it you should use RVM or rbenv. 

Once you have your gemset setup the flow is the following:

```bash
bundle
cp config/database.yml.sample config/database.yml 
rake db:create
rails server
```

Then go to http://localhost:3000/ 
