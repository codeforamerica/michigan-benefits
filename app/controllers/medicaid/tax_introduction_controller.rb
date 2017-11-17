module Medicaid
  class TaxIntroductionController < MedicaidStepsController
    def step_class
      NullStep
    end
  end
end
