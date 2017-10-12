# frozen_string_literal: true

module Medicaid
  class IncomeOtherIncomeType < Step
    step_attributes(
      :income_unemployment,
      :income_pension,
      :income_social_security,
      :income_retirement,
      :income_alimony,
    )
  end
end
