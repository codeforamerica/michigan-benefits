# frozen_string_literal: true

class SkipSendApplicationsController < SnapStepsController
  def create
    flash[:notice] = "Your application has been submitted."
    redirect_to after_submit_path
  end
end
