# frozen_string_literal: true

module Medicaid
  class IncomeOtherIncomeTypeController < MedicaidStepsController
    private

    def skip?
      nobody_with_other_income?
    end

    def nobody_with_other_income?
      !current_application&.anyone_other_income?
    end
  end
end
