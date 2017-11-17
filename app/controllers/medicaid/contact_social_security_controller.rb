module Medicaid
  class ContactSocialSecurityController < Medicaid::ManyMemberStepsController
    def step
      @step ||= step_class.new(
        members: members_requesting_health_insurance,
      )
    end

    private

    def skip?
      no_submit_ssn?
    end

    def no_submit_ssn?
      !current_application&.submit_ssn?
    end

    def member_attrs
      %i[ssn birthday]
    end

    def members_requesting_health_insurance
      current_application.
        members.
        where(requesting_health_insurance: true)
    end
  end
end
