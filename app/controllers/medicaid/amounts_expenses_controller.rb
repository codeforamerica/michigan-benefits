module Medicaid
  class AmountsExpensesController < Medicaid::MemberStepsController
    def current_member
      @_current_member ||= super || first_member_with_expenses
    end

    private

    def update_application
      current_member.update!(step_params)
    end

    def step_class
      Medicaid::AmountsExpenses
    end

    def first_member_with_expenses
      current_application.
        members.
        with_expenses.
        limit(1).
        first
    end

    def next_member
      return if current_member.nil?

      current_application.
        members.
        with_expenses.
        after(current_member).
        limit(1).
        first
    end

    def skip?
      current_application.no_expenses?
    end
  end
end
