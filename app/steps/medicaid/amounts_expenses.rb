# frozen_string_literal: true

module Medicaid
  class AmountsExpenses < Step
    step_attributes(
      :college_loan_interest_expenses,
      :child_support_alimony_arrears_expenses,
    )
  end
end
