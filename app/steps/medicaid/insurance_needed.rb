# frozen_string_literal: true

module Medicaid
  class InsuranceNeeded < Step
    step_attributes(
      :members,
      :requesting_health_insurance,
    )

    def valid?
      if members.select(&:requesting_health_insurance?).any?
        true
      else
        errors.add(
          :requesting_health_insurance,
          "Make sure you select at least one person",
        )
        false
      end
    end
  end
end
