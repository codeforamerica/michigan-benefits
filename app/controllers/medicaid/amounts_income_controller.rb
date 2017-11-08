module Medicaid
  class AmountsIncomeController < Medicaid::MemberStepsController
    def current_member
      @_current_member ||= super || first_member_with_income
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
