# frozen_string_literal: true

module Medicaid
  class AmountsExpensesController < StandardStepsController
    include MedicaidFlow

    private

    def step_class
      Medicaid::AmountsExpenses
    end
  end
end
