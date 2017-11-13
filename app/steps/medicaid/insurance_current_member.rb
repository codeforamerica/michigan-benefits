module Medicaid
  class InsuranceCurrentMember < Step
    step_attributes(
      :insured,
      :members,
    )

    validate :members_needing_insurance_selected

    def members_needing_insurance
      members.select(&:requesting_health_insurance)
    end

    def members_not_needing_insurance
      members.reject(&:requesting_health_insurance)
    end

    def members_needing_insurance_selected
      return true if members_needing_insurance.select(&:insured).any?
      errors.add(
        :insured,
        "Make sure you select a person",
      )
    end
  end
end
