# frozen_string_literal: true

class HouseholdHealth < Step
  step_attributes \
    :any_medical_bill_help_last_3_months,
    :any_lost_insurance_last_3_months

  validates \
    :any_medical_bill_help_last_3_months,
    :any_lost_insurance_last_3_months,
    presence: { message: 'Make sure to answer this question' }
end
