module Integrated
  class LivingSituationController < FormsController
    def update_models
      current_application.update(form_params)
    end
  end
end
