module Integrated
  class ApplicationSubmittedController < FormsController
    before_action :ensure_application_present,
      :send_email,
      only: :edit

    helper_method :current_application

    def edit
      @feedback_form = FeedbackForm.new
      super
    end

    def previous_path(*_args)
      nil
    end

    def next_path
      first_step_path
    end

    private

    def update_models
      current_application.update!(params_for(:application))

      flash[:notice] = "Your application has been sent to your email inbox."
      Integrated::ExportFactory.create(
        destination: :client_email,
        benefit_application: current_application,
      )
    end

    def send_email
      Integrated::ExportFactory.create(
        destination: :office_email,
        benefit_application: current_application,
      )
    end
  end
end
