# frozen_string_literal: true

module Medicaid
  class IncomeJobNumberContinuedController < MedicaidStepsController
    private

    def skip?
      multi_member_household? ||
        not_employed? ||
        current_application.number_of_jobs < 4
    end

    def not_employed?
      !current_application.employed?
    end
  end
end
