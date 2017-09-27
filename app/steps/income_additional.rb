# frozen_string_literal: true

class IncomeAdditional < Step
  step_attributes(
    :income_child_support,
    :income_other,
    :income_pension,
    :income_social_security,
    :income_ssi_or_disability,
    :income_unemployment_insurance,
    :income_workers_compensation,
  )
end
