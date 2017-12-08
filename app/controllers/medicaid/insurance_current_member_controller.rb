module Medicaid
  class InsuranceCurrentMemberController < Medicaid::ManyMemberStepsController
    helper_method :members_not_needing_insurance

    def members_not_needing_insurance
      current_application.members.reject(&:requesting_health_insurance)
    end

    private

    def members
      current_application.members.select(&:requesting_health_insurance)
    end

    def skip?
      single_member_household? || current_application.nobody_insured?
    end

    def member_attrs
      %i[insured]
    end
  end
end
