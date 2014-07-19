ZeroMQ Spike
============

Just experimenting around with using ZeroMQ and Rails. In the MessagesController we build an xml request and then send it via ZeroMQ
to our server. The server then parses the xml and adds the message to the database. To conserve memory, the server only loads ActiveRecord rather than
the whole Rails stack.

This is just a spike so there are no tests and the code is of poor quality.

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
