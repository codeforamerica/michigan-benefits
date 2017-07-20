# frozen_string_literal: true

class IncomeAdditionalSources < Step
  step_attributes \
    :unemployment,
    :ssi,
    :workers_comp,
    :pension,
    :social_security,
    :child_support,
    :foster_care,
    :other
end
