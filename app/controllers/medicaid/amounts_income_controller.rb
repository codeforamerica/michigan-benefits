module Medicaid
  class AmountsIncomeController < Medicaid::MemberStepsController
    private

    def current_member
      @_current_member ||= super || first_member_with_income
    end

    def update_application
      current_member.update!(step_params)
    end

    def first_member_with_income
      current_application.
        members.
        receiving_income.
        limit(1).
        first
    end

    def next_member
      return if current_member.nil?

      current_application.
        members.
        receiving_income.
        after(current_member).
        limit(1).
        first
    end

    def skip?
      current_application.no_one_with_income? ||
        current_member.nil? ||
        current_member&.not_receiving_income?
    end
  end
end
