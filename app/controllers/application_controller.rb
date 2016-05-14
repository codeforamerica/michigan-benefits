class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  respond_to :html

  before_action :verify_allowed_user

  def allowed
    {}
  end

  def verify_allowed_user
    allowed_level = allowed.fetch(action_name.to_sym, :admin)

    allowed = case
      when current_user&.admin? then allowed_level.in? %i[admin user guest]
      when current_user.present? then allowed_level.in? %i[user guest]
      else allowed_level.in? %i[guest]
    end

    unless allowed
      session[:return_to_url] = request.url
      redirect_to new_sessions_path
    end
  end
end
