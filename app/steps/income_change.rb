class IncomeChange < Step
  step_attributes(
    :income_change,
  )

  validates :income_change, inclusion: {
    in: %w(true false),
    message: "Make sure to answer this question",
  }
end
