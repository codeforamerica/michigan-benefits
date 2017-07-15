# frozen_string_literal: true

class IncomeOtherAssets < SimpleStep
  step_attributes \
    :has_accounts,
    :has_home,
    :has_vehicle

  validates \
    :has_accounts,
    :has_home,
    :has_vehicle,
    presence: { message: 'Make sure to answer this question' }
end
