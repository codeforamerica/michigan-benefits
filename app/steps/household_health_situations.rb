# frozen_string_literal: true

class HouseholdHealthSituations < SimpleStep
  step_attributes \
    :household_members,
    :any_medical_bill_help_last_3_months,
    :any_lost_insurance_last_3_months
  #   self.title = 'Your Household'
  #   self.subhead = 'Ok, let us know which people these situations apply to.'
end
