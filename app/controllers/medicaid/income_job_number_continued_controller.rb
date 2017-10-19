# frozen_string_literal: true

module Medicaid
  class IncomeJobNumberContinuedController < MedicaidStepsController
    private

    def skip?
      current_application.number_of_jobs < 4
    end
  end
end
