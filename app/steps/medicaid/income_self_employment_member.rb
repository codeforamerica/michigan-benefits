# frozen_string_literal: true

module Medicaid
  class IncomeSelfEmploymentMember < Step
    step_attributes(:members)

    def valid?
      if members.select(&:self_employed).any?
        true
      else
        errors.add(:self_employed, "Make sure you select at least one person")
        false
      end
    end
  end
end
