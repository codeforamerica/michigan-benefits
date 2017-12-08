module Medicaid
  class InsuranceNeeded < Step
    step_attributes(:members)

    validate :members_requesting_health_insurance_selected

    def members_requesting_health_insurance_selected
      return true if members_requesting_health_insurance.any?
      errors.add(
        :requesting_health_insurance,
        "Make sure you select at least one person",
      )
    end

    private

    def members_requesting_health_insurance
      members.select(&:requesting_health_insurance)
    end
  end
end
