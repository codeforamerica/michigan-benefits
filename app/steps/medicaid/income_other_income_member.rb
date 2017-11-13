module Medicaid
  class IncomeOtherIncomeMember < Step
    step_attributes(:members)

    validate :other_income_selected

    def other_income_selected
      return true if members.select(&:other_income).any?
      errors.add(:other_income, "Make sure you select at least one person")
    end
  end
end
