# frozen_string_literal: true

class IncomeAdditional < Step
  step_attributes \
    :income_child_support,
    :income_unemployment,
    :income_ssi,
    :income_workers_comp,
    :income_pension,
    :income_social_security,
    :income_foster_care,
    :income_other
end
