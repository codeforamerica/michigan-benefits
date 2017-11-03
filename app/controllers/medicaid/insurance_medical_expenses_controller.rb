module Medicaid
  class InsuranceMedicalExpensesController < MedicaidStepsController
    private

    def step_class
      Medicaid::InsuranceMedicalExpenses
    end
  end
end
