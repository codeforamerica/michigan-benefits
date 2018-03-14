module Integrated
  class LivingSituationController < FormsController
    def update_models
      current_application.update(application_params)
    end

    def existing_attributes
      HashWithIndifferentAccess.new(current_application.attributes)
    end
  end
end
