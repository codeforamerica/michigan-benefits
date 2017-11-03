module Medicaid
  class HealthDisabilityMemberController < Medicaid::ManyMemberStepsController
    private

    def skip?
      nobody_disabled? || single_member_household?
    end

    def member_attrs
      %i[disabled]
    end

    def nobody_disabled?
      !current_application.anyone_disabled?
    end
  end
end
