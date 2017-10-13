# frozen_string_literal: true

module Medicaid
  class IncomeOtherIncomeTypeController < MedicaidStepsController
    private

    def skip?
      no_income_not_from_job?
    end

    def no_income_not_from_job?
      !current_application&.income_not_from_job?
    end
  end
end
