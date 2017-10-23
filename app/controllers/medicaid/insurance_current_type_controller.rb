# frozen_string_literal: true

module Medicaid
  class InsuranceCurrentTypeController < Medicaid::ManyMemberStepsController
    private

    def skip?
      not_insured?
    end

    def not_insured?
      current_application.nobody_insured?
    end

    def member_attrs
      %i[insurance_type]
    end
  end
end
