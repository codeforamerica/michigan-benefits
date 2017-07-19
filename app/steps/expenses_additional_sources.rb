# frozen_string_literal: true

class ExpensesAdditionalSources < SimpleStep
  step_attributes \
    :dependent_care,
    :medical,
    :court_ordered,
    :tax_deductible

  validates :dependent_care,
    :medical,
    :court_ordered,
    :tax_deductible,
    presence: { message: 'Make sure to answer this question' }
end
