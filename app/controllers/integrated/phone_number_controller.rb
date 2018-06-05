module Integrated
  class PhoneNumberController < FormsController
    def existing_attributes
      HashWithIndifferentAccess.new(current_application.attributes)
    end

    def update_models
      current_application.update(params_for(:application))
    end
  end
end
