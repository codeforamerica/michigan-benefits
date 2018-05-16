module Integrated
  class LivingSituationController < FormsController
    def update_models
      current_application.update(params_for(:application))
    end

    def existing_attributes
      HashWithIndifferentAccess.new(current_application.attributes)
    end
  end
end
