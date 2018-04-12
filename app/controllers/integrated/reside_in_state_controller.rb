module Integrated
  class ResideInStateController < FormsController
    skip_before_action :ensure_application_present

    def update_models
      if current_application&.navigator.present?
        current_application.navigator.update(form_params)
      else
        application = CommonApplication.create
        application.create_navigator(form_params)
        session[:current_application_id] = application.id
      end
    end
  end
end
