# frozen_string_literal: true

class IncomeAdditionalSources < SimpleStep
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
