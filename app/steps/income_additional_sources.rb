# frozen_string_literal: true

class IncomeAdditionalSources < Step
  step_attributes(
    :child_support,
    :other,
    :pension,
    :social_security,
    :ssi_or_disability,
    :unemployment_insurance,
    :workers_compensation,
  )
end
