# frozen_string_literal: true

class IncomeChange < Step
  step_attributes :income_change

  validates :income_change,
    presence: { message: 'Make sure to answer this question' }
end
