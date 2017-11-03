module Medicaid
  class HealthDisabilityMember < ManyMembersStep
    step_attributes(:members)

    def valid?
      if members.select(&:disabled).any?
        true
      else
        errors.add(:disabled, "Make sure you select at least one person")
        false
      end
    end
  end
end
