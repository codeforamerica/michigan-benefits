class MessagesController < ActionController::Base
  layout "application"

  def new
    @message = Message.new
  end
end