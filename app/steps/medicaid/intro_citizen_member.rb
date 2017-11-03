module Medicaid
  class IntroCitizenMember < ManyMembersStep
    step_attributes(:members)

    def valid?
      if members.select(&:citizen).any?
        true
      else
        errors.add(:citizen, "Make sure you select at least one person")
        false
      end
    end
  end
end
