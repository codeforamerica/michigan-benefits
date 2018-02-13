class MessagesController < ActionController::Base
  layout "application"

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(permitted_params)
    if @message.save
      flash[:success] = "Your message to #{@message.phone} has been sent!"
      redirect_to new_message_path
    else
      render :new
    end
  end

  private

  def permitted_params
    params.require(:message).permit(:phone, :body)
  end
end