class MessagesController < ActionController::Base
  protect_from_forgery with: :exception
  http_basic_authenticate_with(
    name: Rails.application.secrets.basic_auth_caseworker_user,
    password: Rails.application.secrets.basic_auth_caseworker_password,
  )
  layout "application"

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(permitted_params)
    if @message.valid?
      @message.phone = @message.custom_phone if @message.custom_phone.present?
      @message.save
      SmsMessageJob.perform_later(message: @message)
      flash[:success] = "Your message to #{@message.phone} has been sent!"
      redirect_to new_message_path
    else
      render :new
    end
  end

  private

  def permitted_params
    params.require(:message).permit(:phone, :custom_phone, :body, screenshots: [])
  end
end
