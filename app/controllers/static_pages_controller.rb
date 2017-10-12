class StaticPagesController < ApplicationController
  def index
    session[:snap_application_id] = nil
    session[:medicaid_application_id] = nil
  end

  def union
    session[:snap_application_id] = nil
    session[:medicaid_application_id] = nil
  end

  def clio
    session[:snap_application_id] = nil
    session[:medicaid_application_id] = nil
  end

  def dual_index
    session[:snap_application_id] = nil
    session[:medicaid_application_id] = nil
  end
end
