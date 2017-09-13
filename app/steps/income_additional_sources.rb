# frozen_string_literal: true

class IncomeAdditionalSources < Step
  step_attributes(
    :alimony,
    :child_support,
    :foster_care,
    :other,
    :pension,
    :social_security,
    :ssi_or_disability,
    :unemployment_insurance,
    :workers_compensation,
  )
end
