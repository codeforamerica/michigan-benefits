class SkipSendApplicationsController < SnapStepsController
  def create
    flash[:notice] = if current_application.present?
                       "Your application has been submitted."
                     else
                       "Sorry, you can't access that page."
                     end

    redirect_to after_submit_path
  end
end
