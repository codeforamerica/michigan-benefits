# frozen_string_literal: true

module Medicaid
  class InsuranceMedicalExpensesController < MedicaidStepsController
    private

    def step_class
      Medicaid::InsuranceMedicalExpenses
    end
  end
end
