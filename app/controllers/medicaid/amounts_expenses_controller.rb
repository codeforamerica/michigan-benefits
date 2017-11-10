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
      no_self_employment? &&
        no_child_support_alimony_arrears? &&
        no_student_loan_interest?
    end

    def no_self_employment?
      !current_application&.anyone_self_employed?
    end

    def no_child_support_alimony_arrears?
      !current_application&.anyone_pay_child_support_alimony_arrears?
    end

    def no_student_loan_interest?
      !current_application&.anyone_pay_student_loan_interest?
    end
  end
end
