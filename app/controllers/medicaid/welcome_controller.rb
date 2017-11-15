module Medicaid
  class WelcomeController < MedicaidStepsController
    def step_class
      NullStep
    end

    private

    def current_or_new_medicaid_application
      current_application || MedicaidApplication.new
    end

    def ensure_application_present
      true
    end
  end
end
