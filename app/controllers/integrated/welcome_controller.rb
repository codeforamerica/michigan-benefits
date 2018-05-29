module Integrated
  class WelcomeController < FormsController
    skip_before_action :ensure_application_present

    def update_models
      unless current_application.present?
        application = CommonApplication.create
        application.create_navigator
        session[:current_application_id] = application.id
      end
    end

    def form_class
      NullStep
    end
  end
end
