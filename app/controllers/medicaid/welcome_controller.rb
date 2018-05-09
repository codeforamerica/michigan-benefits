module Medicaid
  class WelcomeController < MedicaidStepsController
    skip_before_action :ensure_application_present

    def edit
      @step = step_class.new(office_page: office_page)
    end

    private

    def office_page
      if params[:office_page].present?
        params[:office_page]
      elsif current_application
        current_application.office_page
      end
    end

    def update_application
      application = current_or_new_application
      application.update!(step_params)
      set_current_application(application) unless current_application
    end

    def set_current_application(application)
      session[:medicaid_application_id] = application.id
    end

    def current_or_new_application
      current_application || MedicaidApplication.new
    end
  end
end
