# frozen_string_literal: true

class ExpensesAdditional < Step
  step_attributes(
    :alimony,
    :care_expenses,
    :child_support,
    :childcare,
    :co_pays,
    :court_ordered_expenses,
    :dental,
    :disabled_adult_care,
    :elderly_care,
    :health_insurance,
    :hospital_bills,
    :in_home_care,
    :medical_expenses,
    :monthly_care_expenses,
    :monthly_court_ordered_expenses,
    :monthly_medical_expenses,
    :monthly_tax_deductible_expenses,
    :other,
    :other_tax_deductible,
    :prescriptions,
    :student_loan_interest,
    :tax_deductible_expenses,
    :transportation,
  )
end
