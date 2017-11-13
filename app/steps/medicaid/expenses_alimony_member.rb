module Medicaid
  class ExpensesAlimonyMember < Step
    step_attributes(:members)

    validate :pay_child_support_alimony_arrears_selected

    def pay_child_support_alimony_arrears_selected
      return true if members.select(&:pay_child_support_alimony_arrears).any?
      errors.add(
        :child_support_alimony_arrears,
        "Make sure you select at least one person",
      )
    end
  end
end
