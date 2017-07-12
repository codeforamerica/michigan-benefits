# frozen_string_literal: true

class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception # Prevent CSRF attacks by raising an exception. For APIs, you may want to use :null_session instead.
  force_ssl if: -> { Feature.ssl? }
  before_action :basic_auth, :verify_allowed_user

  respond_to :html

  def basic_auth
    basic_auth_name, basic_auth_password = ENV.fetch('BASIC_AUTH', '').split(':')

    if basic_auth_name.present? && basic_auth_password.present?
      authenticate_or_request_with_http_basic(Rails.application.config.site_name) do |name, password|
        ActiveSupport::SecurityUtils.variable_size_secure_compare(name, basic_auth_name) &
          ActiveSupport::SecurityUtils.variable_size_secure_compare(password, basic_auth_password)
      end
    else
      true
    end
  end

  def allowed
    {}
  end

  def verify_allowed_user
    allowed_level = allowed.fetch(action_name.to_sym, :admin)

    allowed = if current_user&.admin? then allowed_level.in? %i[admin member guest]
              elsif current_user.present? then allowed_level.in? %i[member guest]
              else allowed_level.in? %i[guest]
    end

    unless allowed
      session[:return_to_url] = request.url
      redirect_to new_sessions_path
    end
  end

  def current_app
    @current_app ||= App.find_or_create_by!(user: current_user)
  end
end
