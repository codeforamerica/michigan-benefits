module Medicaid
  class IncomeSelfEmploymentMember < Step
    step_attributes(:members)

    validate :self_employed_selected

    def self_employed_selected
      return true if members.select(&:self_employed).any?
      errors.add(:self_employed, "Make sure you select at least one person")
    end
  end
end
