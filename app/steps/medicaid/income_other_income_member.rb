# frozen_string_literal: true

module Medicaid
  class IncomeOtherIncomeMember < Step
    step_attributes(:members)

    def valid?
      if members.select(&:other_income).any?
        true
      else
        errors.add(:other_income, "Make sure you select at least one person")
        false
      end
    end
  end
end
