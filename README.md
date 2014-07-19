ZeroMQ Spike
============

Just experimenting around with using ZeroMQ and Rails.

Prerequisites
-------------

```
brew install zeromq
```

Setup
-----

```
git clone git@github.com:andypike/zero.git
cd zero
cp config/example.database.yml config/database.yml
  * Change the db user in database.yml to zero
psql postgres
  # create user zero with password '' CREATEDB;
  # \q
bundle
rake db:create db:migrate
rails s
```

ZeroMQ server
-------------

Start the server running with:

```
ruby app/servers/message_server.rb
```
