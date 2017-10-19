# frozen_string_literal: true

module Medicaid
  class AmountsIncome < Step
    step_attributes(
      :self_employed_monthly_income,
      :unemployment_income,
      :employed_monthly_income_0,
      :employed_monthly_income_1,
      :employed_monthly_income_2,
      :employed_monthly_income_3,
      :employed_monthly_income_4,
      :employed_monthly_income_5,
      :employed_monthly_income_6,
      :employed_monthly_income_7,
      :employed_monthly_income_8,
      :employed_monthly_income_9,
      employed_monthly_income: [],
    )
  end
end
