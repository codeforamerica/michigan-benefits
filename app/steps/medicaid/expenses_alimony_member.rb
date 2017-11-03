module Medicaid
  class ExpensesAlimonyMember < ManyMembersStep
    step_attributes(:members)

    def valid?
      if members.select(&:pay_child_support_alimony_arrears).any?
        true
      else
        errors.add(
          :child_support_alimony_arrears,
          "Make sure you select at least one person",
        )
        false
      end
    end
  end
end
