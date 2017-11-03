module Medicaid
  class InsuranceNeeded < Step
    step_attributes(
      :members,
      :requesting_health_insurance,
    )

    def valid?
      if members_requesting_health_insurance.any?
        true
      else
        errors.add(
          :requesting_health_insurance,
          "Make sure you select at least one person",
        )
        false
      end
    end

    private

    def members_requesting_health_insurance
      members.select(&:requesting_health_insurance)
    end
  end
end
