module Integrated
  class HasYourIncomeChangedController < FormsController
    def update_models
      current_application.update(application_params)
    end
  end
end
