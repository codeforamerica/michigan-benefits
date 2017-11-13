module Medicaid
  class ExpensesAlimonyMember < ManyMembersStep
    step_attributes(:members)

    def members_valid
      return true if members.select(&:pay_child_support_alimony_arrears).any?
      errors.add(
        :child_support_alimony_arrears,
        "Make sure you select at least one person",
      )
    end
  end
end
