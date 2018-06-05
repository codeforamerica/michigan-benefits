module Integrated
  class AnythingElseController < FormsController
    def existing_attributes
      { additional_information: current_application.additional_information }
    end

    def update_models
      current_application.update!(params_for(:application))
    end
  end
end
