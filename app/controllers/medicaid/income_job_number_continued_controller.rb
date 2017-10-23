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

    def multi_member_household?
      current_application.members.count != 1
    end
  end
end
