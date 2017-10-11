# frozen_string_literal: true

module Medicaid
  class InsuranceCurrentTypeController < StandardStepsController
    include MedicaidFlow

    private

    def skip?
      not_insured?
    end

    def not_insured?
      !current_application&.insured?
    end
  end
end
