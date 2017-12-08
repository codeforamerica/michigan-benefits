module Medicaid
  class AmountsIncome < MemberStep
    step_attributes(
      :employments,
      :self_employed_monthly_income,
      :unemployment_income,
      :id,
    )
  end
end
