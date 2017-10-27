# frozen_string_literal: true

module Medicaid
  class InsuranceCurrentMemberController < Medicaid::ManyMemberStepsController
    private

    def skip?
      single_member_household? || current_application.nobody_insured?
    end

    def member_attrs
      %i[insured]
    end
  end
end
