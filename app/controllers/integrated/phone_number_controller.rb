module Integrated
  class PhoneNumberController < FormsController
    def update_models
      current_application.update(params_for(:application))
    end
  end
end
