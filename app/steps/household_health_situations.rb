# frozen_string_literal: true

class HouseholdHealthSituations < Step
  step_attributes \
    :household_members,
    :any_medical_bill_help_last_3_months,
    :any_lost_insurance_last_3_months
end
