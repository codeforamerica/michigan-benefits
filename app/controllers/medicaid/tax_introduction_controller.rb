module Medicaid
  class TaxIntroductionController < MedicaidStepsController
    def step_class
      NullStep
    end

    def update
      redirect_to(next_path)
    end
  end
end
