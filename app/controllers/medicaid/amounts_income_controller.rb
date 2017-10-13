# frozen_string_literal: true

module Medicaid
  class AmountsIncomeController < MedicaidStepsController
    private

    def skip?
      not_employed? && not_self_employed? && not_receiving_unemployment?
    end

    def not_employed?
      !current_application&.employed?
    end

    def not_self_employed?
      !current_application&.self_employed?
    end

    def not_receiving_unemployment?
      !current_application&.income_unemployment?
    end
  end
end
