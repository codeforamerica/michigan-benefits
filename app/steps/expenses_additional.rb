# frozen_string_literal: true

class ExpensesAdditional < SimpleStep
  step_attributes \
    :monthly_care_expenses,
    :childcare,
    :elderly_care,
    :disabled_adult_care,
    :monthly_medical_expenses,
    :health_insurance,
    :co_pays,
    :prescriptions,
    :dental,
    :in_home_care,
    :transportation,
    :hospital_bills,
    :other,
    :monthly_court_ordered_expenses,
    :child_support,
    :alimony,
    :monthly_tax_deductible_expenses,
    :student_loan_interest,
    :other_tax_deductible
end
