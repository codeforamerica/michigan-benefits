module Integrated
  class LivingSituationController < FormsController
    def update_models
      current_application.update(application_params)
    end
  end
end
