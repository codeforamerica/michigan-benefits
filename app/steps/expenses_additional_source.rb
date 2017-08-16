# frozen_string_literal: true

class ExpensesAdditionalSource < Step
  step_attributes(
    :court_ordered,
    :dependent_care,
    :medical,
    :tax_deductible,
  )

  validates :court_ordered,
    :dependent_care,
    :medical,
    :tax_deductible,
    inclusion: {
      in: [true, false],
      message: "Make sure to answer this question",
    }
end
