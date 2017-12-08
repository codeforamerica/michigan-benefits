module Medicaid
  class IntroMaritalStatusMember < Step
    step_attributes(:members)

    validate :married_selected

    def married_selected
      return true if members.select(&:married?).any?
      errors.add(:married, "Make sure you select at least one person")
    end
  end
end
