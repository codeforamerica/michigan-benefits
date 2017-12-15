module Medicaid
  class IntroLocationController < MedicaidStepsController
    skip_before_action :ensure_application_present

    def edit
      super
      if params[:office_location].present?
        app = current_or_new_medicaid_application
        app.update!(office_location: params[:office_location])
        set_current_application(app)
      end
    end

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
