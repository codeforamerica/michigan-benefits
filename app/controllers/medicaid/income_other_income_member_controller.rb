# frozen_string_literal: true

module Medicaid
  class IncomeOtherIncomeMemberController < Medicaid::ManyMemberStepsController
    private

    def skip?
      single_member_household? || !current_application.anyone_other_income?
    end

    def member_attrs
      %i[other_income]
    end
  end
end
