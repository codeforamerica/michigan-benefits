class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception. For APIs, you may want to use
  # :null_session instead.
  protect_from_forgery with: :exception

  respond_to :html

  helper_method \
    :current_application,
    :current_path,
    :next_path,
    :previous_path,
    :skip_path

  delegate :variable_size_secure_compare, to: ActiveSupport::SecurityUtils

  def previous_path(*); end

  def current_path(*); end

  def next_path(*); end
end
