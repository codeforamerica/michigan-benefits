module Medicaid
  class IncomeIntroductionController < MedicaidStepsController
    def step_class
      NullStep
    end
  end
end
