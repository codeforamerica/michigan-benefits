module Medicaid
  class WelcomeController < MedicaidStepsController
    def step_class
      NullStep
    end

    private

    def ensure_application_present
      true
    end
  end
end
