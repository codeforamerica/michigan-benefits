module Medicaid
  class AmountsIncome < Step
    step_attributes(
      :employed_monthly_income,
      :self_employed_monthly_income,
      :unemployment_income,
      :member_id,
    )
  end
end
