# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception. For APIs, you may want to use
  # :null_session instead.
  protect_from_forgery with: :exception

  respond_to :html

  helper_method \
    :current_path,
    :current_snap_application,
    :next_path,
    :previous_path,
    :skip_path

  delegate :variable_size_secure_compare, to: ActiveSupport::SecurityUtils

  def previous_path(*); end

  def current_path(*); end

  def next_path(*); end

  def set_current_snap_application(application)
    session[:snap_application_id] = application.try(:id)
  end

  def current_snap_application
    SnapApplication.find_by(id: current_snap_application_id)
  end

  def current_snap_application_id
    session[:snap_application_id]
  end
end
