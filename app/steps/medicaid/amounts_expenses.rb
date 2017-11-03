module Medicaid
  class AmountsExpenses < Step
    step_attributes(
      :child_support_alimony_arrears_expenses,
      :college_loan_interest_expenses,
      :self_employed,
      :self_employment_expenses,
    )

    validates :self_employment_expenses,
      presence: { message: "Make sure to answer this question" },
      if: :self_employed?

    private

    def self_employed?
      self_employed == "true"
    end
  end
end
