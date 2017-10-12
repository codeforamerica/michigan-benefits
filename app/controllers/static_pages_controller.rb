class StaticPagesController < ApplicationController
  before_action :clear_session

  def index; end

  def union; end

  def clio; end

  def dual_index; end

  private

  def clear_session
    session[:snap_application_id] = nil
    session[:medicaid_application_id] = nil
  end
end
