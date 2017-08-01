class PagesController < ApplicationController
  def index
    session[:snap_application_id] = nil
  end
end
