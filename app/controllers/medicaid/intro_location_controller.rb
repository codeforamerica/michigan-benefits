module Medicaid
  class IntroLocationController < MedicaidStepsController
    skip_before_action :ensure_application_present

    def update
      @step = step_class.new(step_params)

      if @step.valid?
        app = current_or_new_medicaid_application
        app.update!(michigan_resident: step_params[:michigan_resident])
        set_current_application(app)
        redirect_to(next_path)
      else
        render :edit
      end
    end

    private

    def current_or_new_medicaid_application
      current_application || MedicaidApplication.new
    end
  end
end
