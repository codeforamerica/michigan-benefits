# frozen_string_literal: true

class IncomeAdditional < SimpleStep
=begin
  self.subhead = 'Tell us more about your additional income.'
=end

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
