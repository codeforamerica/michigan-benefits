class SkipSendApplicationsController < ApplicationController
  include SnapFlow

  def create
    flash[:notice] = "Your application has been submitted."
    redirect_to root_path(anchor: "fold")
  end
end
