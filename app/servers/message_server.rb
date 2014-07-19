require "ffi-rzmq"
require "yaml"
require "active_record"
require_relative "../models/message"

environment = "development"
db_config_file = File.expand_path("../../../config/database.yml", __FILE__)
connection_info = YAML.load_file(db_config_file)[environment]
ActiveRecord::Base.establish_connection(connection_info)

context = ZMQ::Context.new
socket  = context.socket(ZMQ::REP)
socket.bind("tcp://*:5555")

puts "Server started. Waiting for requests..."
loop do
  request = ""
  socket.recv_string(request)

  Message.create(:text => request)

  puts "Received request. Data: #{request}"
  socket.send_string("OK")
end
