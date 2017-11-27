module Medicaid
  class AmountsIncome < MemberStep
    step_attributes(
      {
        employed_pay_quantities: [],
        employed_employer_names: [],
        employed_payment_frequency: [],
      },
      :self_employed_monthly_income,
      :unemployment_income,
      :id,
    )
  end
end
