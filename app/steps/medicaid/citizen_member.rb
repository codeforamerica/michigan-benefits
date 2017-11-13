module Medicaid
  class IntroCitizenMember < ManyMembersStep
    step_attributes(:members)

    def members_valid
      return true if members.select(&:citizen).any?
      errors.add(:citizen, "Make sure you select at least one person")
    end
  end
end
