# frozen_string_literal: true

class IncomeOtherAssets < Step
  step_attributes(
    :money_or_accounts_income,
    :real_estate_income,
    :vehicle_income,
  )

  validates :money_or_accounts_income, inclusion: {
    in: %w(true false),
    message: "Make sure to answer this question",
  }

  validates :real_estate_income, inclusion: {
    in: %w(true false),
    message: "Make sure to answer this question",
  }

  validates :vehicle_income, inclusion: {
    in: %w(true false),
    message: "Make sure to answer this question",
  }
end
