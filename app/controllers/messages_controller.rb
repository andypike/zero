class MessagesController < ApplicationController
  def index
    @messages = Message.order(:created_at)
  end

  def create
    send_message(params[:message][:text])
    redirect_to messages_path
  end

  private

  def send_message(text)
    context = ZMQ::Context.new
    request = context.socket(ZMQ::REQ)
    request.connect("tcp://localhost:5555")

    request.send_string(text)

    response = ""
    request.recv_string(response)
    puts "Received response. Data: #{response}"

    request.close
    context.terminate
  end
end
