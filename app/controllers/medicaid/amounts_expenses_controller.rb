module Medicaid
  class AmountsExpensesController < Medicaid::MemberStepsController
    def current_member
      @_current_member ||= super || first_member_with_expenses
    end

    def update
      @step = step_class.new(
        step_params.merge(member_id: current_member.id),
      )

      if @step.valid?
        current_member.update!(step_params)
        redirect_to(next_path)
      else
        render :edit
      end
    end

    private

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
