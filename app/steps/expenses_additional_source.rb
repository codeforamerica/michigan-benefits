class ExpensesAdditionalSource < Step
  step_attributes(
    :court_ordered,
    :dependent_care,
    :medical,
  )

  validates :court_ordered,
    :dependent_care,
    :medical,
    inclusion: {
      in: [true, false],
      message: "Make sure to answer this question",
    }
end
