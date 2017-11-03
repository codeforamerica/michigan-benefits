module Medicaid
  class InsuranceNeededController < Medicaid::ManyMemberStepsController
    private

    def skip?
      single_member_household?
    end

    def member_attrs
      %i[requesting_health_insurance]
    end
  end
end
