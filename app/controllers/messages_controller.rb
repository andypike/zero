class MessagesController < ApplicationController
  def index
    @messages = Message.order(:created_at)
  end

  def create
    send_message(params[:message][:text])
    redirect_to messages_path
  end

  private

  def send_message(message_text)
    context = ZMQ::Context.new
    request = context.socket(ZMQ::REQ)
    request.connect("tcp://localhost:5555")

    request_xml = build_request(message_text)
    request.send_string(request_xml)

    response = ""
    request.recv_string(response)
    puts "Received response. Data: #{response}"

    request.close
    context.terminate
  end

  def build_request(message_text)
    doc = Ox::Document.new(:version => "1.0")

    root = Ox::Element.new("Command")
    doc << root

    header = Ox::Element.new("Header")
    root << header

    command = Ox::Element.new("CommandName")
    command << "NewMessage"
    root << command

    inputs = Ox::Element.new("Inputs")
    root << inputs

    text = Ox::Element.new("Text")
    text << message_text
    inputs << text

    Ox.dump(doc)
  end
end
