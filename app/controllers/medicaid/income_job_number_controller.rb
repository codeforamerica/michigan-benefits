# frozen_string_literal: true

module Medicaid
  class IncomeJobNumberController < StandardStepsController
    include MedicaidFlow

    private

    def skip?
      not_employed?
    end

    def not_employed?
      !current_application&.employed?
    end
  end
end
