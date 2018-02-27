module Integrated
  class ApplicationSubmittedController < FormsController
    before_action :ensure_application_present,
      :send_email,
      :clear_current_application,
      only: :edit

    def form_class
      NullStep
    end

    def previous_path(*_args)
      nil
    end

    def next_path
      first_step_path
    end

    private

    def send_email
      Integrated::ExportFactory.create(
        destination: :office_email,
        benefit_application: current_application,
      )
    end

    def clear_current_application
      session[:current_application_id] = nil
    end
  end
end
