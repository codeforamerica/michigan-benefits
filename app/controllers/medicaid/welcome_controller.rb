module Medicaid
  class WelcomeController < MedicaidStepsController
    skip_before_action :ensure_application_present

    def step_class
      NullStep
    end
  end
end
