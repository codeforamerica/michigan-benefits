module Medicaid
  class HealthDisabilityMember < Step
    step_attributes(:members)

    validate :disabled_selected

    def disabled_selected
      return true if members.select(&:disabled).any?
      errors.add(:disabled, "Make sure you select at least one person")
    end
  end
end
