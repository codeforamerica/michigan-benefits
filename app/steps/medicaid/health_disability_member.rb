module Medicaid
  class HealthDisabilityMember < ManyMembersStep
    step_attributes(:members)

    def members_valid
      return true if members.select(&:disabled).any?
      errors.add(:disabled, "Make sure you select at least one person")
    end
  end
end
