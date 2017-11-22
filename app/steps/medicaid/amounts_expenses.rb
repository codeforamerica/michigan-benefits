module Medicaid
  class AmountsExpenses < Step
    step_attributes(
      :child_support_alimony_arrears_expenses,
      :id,
      :self_employed,
      :self_employed_monthly_expenses,
      :student_loan_interest_expenses,
    )

    validates :self_employed_monthly_expenses,
      presence: { message: "Make sure to answer this question" },
      if: :self_employed?

    private

    def self_employed?
      self_employed == "true"
    end
  end
end
