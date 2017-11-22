module Medicaid
  class InsuranceCurrentTypeController < Medicaid::MemberStepsController
    private

    def update_application
      current_member.update!(step_params)
    end

    def current_member
      @_current_member ||= super || first_insurance_holder
    end

    def first_insurance_holder
      current_application.
        members.
        insured.
        limit(1).
        first
    end

    def next_member
      return if current_member.nil?

      current_application.
        members.
        insured.
        after(current_member).
        limit(1).
        first
    end

    def skip?
      current_application.nobody_insured?
    end

    def member_attrs
      %i[insurance_type]
    end
  end
end
