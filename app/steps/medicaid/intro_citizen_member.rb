module Medicaid
  class IntroCitizenMember < Step
    step_attributes(:members)

    validate :citizen_selected

    def citizen_selected
      return true if members.select(&:citizen).any?
      errors.add(:citizen, "Make sure you select at least one person")
    end
  end
end
