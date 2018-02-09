require "administrate/base_dashboard"

class MedicaidApplicationDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    members: Field::HasMany,
    addresses: Field::HasMany,
    employments: Field::HasMany,
    id: Field::Number,
    michigan_resident: Field::Boolean,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    submit_ssn: Field::Boolean,
    homeless: Field::Boolean,
    reliable_mail_address: Field::Boolean,
    need_medical_expense_help_3_months: Field::Boolean,
    income_unemployment: Field::Boolean,
    income_pension: Field::Boolean,
    income_social_security: Field::Boolean,
    income_retirement: Field::Boolean,
    income_alimony: Field::Boolean,
    filing_federal_taxes_next_year: Field::Boolean,
    college_loan_interest_expenses: Field::Number,
    child_support_alimony_arrears_expenses: Field::Number,
    phone_number: Field::String,
    sms_phone_number: Field::String,
    email: Field::String,
    last_emailed_office_at: Field::DateTime,
    sms_consented: Field::Boolean,
    birthday: Field::DateTime,
    self_employment_expenses: Field::Number,
    employed_monthly_income: Field::String.with_options(searchable: false),
    anyone_in_college: Field::Boolean,
    flint_water_crisis: Field::Boolean,
    anyone_employed: Field::Boolean,
    everyone_a_citizen: Field::Boolean,
    anyone_new_mom: Field::Boolean,
    anyone_self_employed: Field::Boolean,
    anyone_other_income: Field::Boolean,
    anyone_insured: Field::Boolean,
    anyone_disabled: Field::Boolean,
    anyone_pay_child_support_alimony_arrears: Field::Boolean,
    anyone_pay_student_loan_interest: Field::Boolean,
    anyone_caretaker_or_parent: Field::Boolean,
    consent_to_terms: Field::Boolean,
    encrypted_last_four_ssn: Field::String,
    encrypted_last_four_ssn_iv: Field::String,
    signature: Field::String,
    signed_at: Field::DateTime,
    upload_paperwork: Field::Boolean,
    paperwork: Field::String.with_options(searchable: false),
    office_location: Field::String,
    mailing_address_same_as_residential_address: Field::Boolean,
    stable_housing: Field::Boolean,
    anyone_married: Field::Boolean,
    exports: Field::HasMany,
    applied_before: Field::String.with_options(searchable: false),
  }.freeze

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = %i[
    id
    phone_number
    office_location
    email
    signed_at
    last_emailed_office_at
  ].freeze

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = %i[
    id
    members
    exports
    addresses
    employments
    michigan_resident
    created_at
    updated_at
    submit_ssn
    applied_before
    homeless
    reliable_mail_address
    need_medical_expense_help_3_months
    income_unemployment
    income_pension
    income_social_security
    income_retirement
    income_alimony
    filing_federal_taxes_next_year
    college_loan_interest_expenses
    child_support_alimony_arrears_expenses
    phone_number
    sms_phone_number
    email
    sms_consented
    birthday
    self_employment_expenses
    employed_monthly_income
    anyone_in_college
    flint_water_crisis
    anyone_employed
    everyone_a_citizen
    anyone_new_mom
    anyone_self_employed
    anyone_other_income
    anyone_insured
    anyone_disabled
    anyone_pay_child_support_alimony_arrears
    anyone_pay_student_loan_interest
    anyone_caretaker_or_parent
    consent_to_terms
    encrypted_last_four_ssn
    encrypted_last_four_ssn_iv
    signature
    signed_at
    upload_paperwork
    paperwork
    office_location
    mailing_address_same_as_residential_address
    stable_housing
    anyone_married
  ].freeze

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = %i[
    members
    addresses
    michigan_resident
    submit_ssn
    homeless
    reliable_mail_address
    need_medical_expense_help_3_months
    income_unemployment
    income_pension
    income_social_security
    income_retirement
    income_alimony
    filing_federal_taxes_next_year
    college_loan_interest_expenses
    child_support_alimony_arrears_expenses
    phone_number
    sms_phone_number
    email
    sms_consented
    birthday
    self_employment_expenses
    employed_monthly_income
    anyone_in_college
    flint_water_crisis
    anyone_employed
    everyone_a_citizen
    anyone_new_mom
    anyone_self_employed
    anyone_other_income
    anyone_insured
    anyone_disabled
    anyone_pay_child_support_alimony_arrears
    anyone_pay_student_loan_interest
    anyone_caretaker_or_parent
    consent_to_terms
    encrypted_last_four_ssn
    encrypted_last_four_ssn_iv
    signature
    signed_at
    upload_paperwork
    paperwork
    office_location
    mailing_address_same_as_residential_address
    stable_housing
    anyone_married
  ].freeze

  def display_resource(medicaid_application)
    "Medicaid Application ##{medicaid_application.id}"
  end
end
