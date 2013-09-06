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

Versions
======= 

This is tested to work using 
Ruby - 2.0.0p195
Rails - 4.0.0
