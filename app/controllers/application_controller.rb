class ApplicationController < ActionController::Base
  include Pundit

  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # one password for the entire site, for while the site's in closed beta
  if Rails.application.config.require_beta_login
    http_basic_authenticate_with name: Rails.application.config.beta_username,
                                 password: Rails.application.config.beta_password
  end

  # require account logins for all pages by default
  # (public pages use skip_before_filter :require_login)
  before_filter :require_login

  # called from before_filter :require_login
  def not_authenticated
    redirect_to new_session_path
  end

  # called when a policy authorization fails
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized
  def not_authorized
    redirect_to new_session_path
  end

  # use like: before_filter :require_admin
  def require_admin
    authorize :admin, :admin?
  end
end
