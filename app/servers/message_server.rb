require "ffi-rzmq"
require "yaml"
require "active_record"
require "ox"
require_relative "../models/message"

def load_active_record(environment)
  db_config_file = File.expand_path("../../../config/database.yml", __FILE__)
  connection_info = YAML.load_file(db_config_file)[environment]
  ActiveRecord::Base.establish_connection(connection_info)
end

def start_server(port)
  context = ZMQ::Context.new
  socket  = context.socket(ZMQ::REP)
  socket.bind("tcp://*:#{port}")

  puts "Server started. Waiting for requests..."
  loop do
    xml = ""
    socket.recv_string(xml)
    puts "Received request. Data: #{xml}"

    doc = Ox.parse(xml)
    message_text = doc.locate("Inputs/Text").first.text

    Message.create(:text => message_text)

    response_xml = build_response
    socket.send_string(response_xml)
  end
end

def build_response
  doc = Ox::Document.new(:version => "1.0")

  root = Ox::Element.new("Response")
  doc << root

  header = Ox::Element.new("Header")
  root << header

  command = Ox::Element.new("CommandName")
  command << "NewMessage"
  root << command

  ret = Ox::Element.new("Return")
  root << ret

  success = Ox::Element.new("Success")
  success << "True"
  ret << success

  Ox.dump(doc)
end

load_active_record("development")
start_server(5555)
