module Medicaid
  class ExpensesAlimony < Step
    step_attributes(
      :anyone_pay_child_support_alimony_arrears,
      :members,
    )
  end
end
