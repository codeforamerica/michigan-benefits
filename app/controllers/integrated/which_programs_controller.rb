module Integrated
  class WhichProgramsController < FormsController
    skip_before_action :ensure_application_present

    def update_models
      unless current_application.present?
        application = CommonApplication.create
        application.create_navigator
        session[:current_application_id] = application.id
      end
      current_application.navigator.update(params_for(:navigator))
    end

    def existing_attributes
      if current_application.present?
        {
          applying_for_food: current_application.navigator.applying_for_food,
          applying_for_healthcare: current_application.navigator.applying_for_healthcare,
        }
      else
        {}
      end
    end
  end
end
