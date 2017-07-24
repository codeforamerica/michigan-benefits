# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception. For APIs, you may want to use
  # :null_session instead.
  protect_from_forgery with: :exception
  force_ssl if: -> { Feature.ssl? }
  before_action :basic_auth, :verify_allowed_user

  respond_to :html

  helper_method :previous_path, :current_path, :next_path, :current_app

  delegate :variable_size_secure_compare, to: ActiveSupport::SecurityUtils

  def basic_auth
    basic_auth_name, basic_auth_password = ENV.fetch("BASIC_AUTH", "").split(":")

    if basic_auth_name.present? && basic_auth_password.present?
      site_name = Rails.application.config.site_name
      authenticate_or_request_with_http_basic(site_name) do |name, password|
        variable_size_secure_compare(name, basic_auth_name) &
          variable_size_secure_compare(password, basic_auth_password)
      end
    else
      true
    end
  end

  def allowed
    {}
  end

  def verify_allowed_user
    return if allowed?
    session[:return_to_url] = request.url
    redirect_to new_sessions_path
  end

  def allowed?
    allowed_level = allowed.fetch(action_name.to_sym, :admin)

    if current_user&.admin?
      allowed_level.in? %i[admin member guest]
    elsif current_user.present?
      allowed_level.in? %i[member guest]
    else
      allowed_level.in? %i[guest]
    end
  end

  def previous_path(*); end

  def current_path(*); end

  def next_path(*); end

  def current_app
    @current_app ||= App.find_or_create_by!(user: current_user)
  end
end
