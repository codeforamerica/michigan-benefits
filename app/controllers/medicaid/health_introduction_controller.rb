module Medicaid
  class HealthIntroductionController < MedicaidStepsController
    def step_class
      NullStep
    end
  end
end
