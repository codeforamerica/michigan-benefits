# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception. For APIs, you may want to use
  # :null_session instead.
  protect_from_forgery with: :exception
  force_ssl if: -> { Feature.ssl? }

  respond_to :html

  helper_method :previous_path, :current_path, :next_path, :current_snap_application, :current_or_new_snap_application

  delegate :variable_size_secure_compare, to: ActiveSupport::SecurityUtils

  def previous_path(*); end

  def current_path(*); end

  def next_path(*); end

  def set_current_snap_application(application)
    session[:snap_application_id] = application.try(:id)
  end

  def current_or_new_snap_application
    current_snap_application || SnapApplication.create
  end

  def current_snap_application
    id = current_snap_application_id
    SnapApplication.find_by(id: id)
  end

  def current_snap_application_id
    session[:snap_application_id]
  end
end
