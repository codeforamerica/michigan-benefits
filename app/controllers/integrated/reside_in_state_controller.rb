module Integrated
  class ResideInStateController < FormsController
    def update_models
      if current_application.navigator.present?
        current_application.navigator.update(form_params)
      else
        current_application.create_navigator(form_params)
      end
    end
  end
end
