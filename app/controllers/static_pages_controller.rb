class StaticPagesController < ApplicationController
  before_action :clear_session

  helper_method :step_path

  def index; end

  def union; end

  def clio; end

  def step_path(*args)
    super.gsub("%2F", "/")
  end

  private

  def clear_session
    session[:snap_application_id] = nil
    session[:medicaid_application_id] = nil
  end
end
