module Medicaid
  class PaperworkIncomeProofController < Medicaid::MemberStepsController
    def current_member
      @_current_member ||= super || first_member_employed
    end

    private

    def update_application
      member_from_form.update(step_params)
    end

    def skip?
      current_application.no_one_with_income? ||
        current_member.nil? ||
        current_member.not_receiving_income?
    end

    def first_member_employed
      current_application.
        members.
        employed_or_self_employed.
        limit(1).
        first
    end

    def next_member
      return if current_member.nil?

      current_application.
        members.
        employed_or_self_employed.
        after(current_member).
        limit(1).
        first
    end
  end
end
