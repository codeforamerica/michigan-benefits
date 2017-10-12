# frozen_string_literal: true

module Medicaid
  class InsuranceMedicalExpensesController < StandardStepsController
    include MedicaidFlow

    private

    def step_class
      Medicaid::InsuranceMedicalExpenses
    end
  end
end
