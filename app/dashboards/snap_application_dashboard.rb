require "administrate/base_dashboard"

class SnapApplicationDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    additional_income: Field::Text,
    anyone_disabled: Field::Boolean,
    anyone_in_college: Field::Boolean,
    anyone_living_elsewhere: Field::Boolean,
    anyone_new_mom: Field::Boolean,
    care_expenses: Field::String,
    consent_to_terms: Field::Boolean,
    court_ordered: Field::Boolean,
    court_ordered_expenses: Field::String,
    created_at: Field::DateTime,
    dependent_care: Field::Boolean,
    documents: Field::String,
    email: Field::String,
    emailed_at: Field::DateTime,
    everyone_a_citizen: Field::Boolean,
    fax_metadata: Field::String,
    faxed_successfully_at: Field::DateTime,
    financial_accounts: Field::String,
    income_change: Field::Boolean,
    income_change_explanation: Field::Text,
    income_child_support: Field::Text,
    income_other: Field::String,
    income_pension: Field::String,
    income_social_security: Field::String,
    income_ssi_or_disability: Field::String,
    income_unemployment_insurance: Field::String,
    income_workers_compensation: Field::String,
    insurance_expense: Field::String,
    mailing_address_same_as_residential_address: Field::Boolean,
    medical: Field::Boolean,
    medical_expenses: Field::String,
    money_or_accounts_income: Field::Boolean,
    monthly_care_expenses: Field::String,
    monthly_court_ordered_expenses: Field::String,
    monthly_medical_expenses: Field::String,
    receiving_office_name: Field::String,
    phone_number: Field::String,
    property_tax_expense: Field::Number,
    real_estate_income: Field::Boolean,
    rent_expense: Field::Number,
    signature: Field::String,
    signed_at: Field::DateTime,
    sms_consented: Field::Boolean,
    total_money: Field::Number,
    unstable_housing: Field::Boolean,
    updated_at: Field::DateTime,
    utility_cooling: Field::Boolean,
    utility_electrity: Field::Boolean,
    utility_heat: Field::Boolean,
    utility_other: Field::Boolean,
    utility_phone: Field::Boolean,
    utility_trash: Field::Boolean,
    utility_water_sewer: Field::Boolean,
    vehicle_income: Field::Boolean,
    zip: Field::String,
    members: Field::HasMany,
    driver_errors: Field::HasMany,
    exports: Field::HasMany,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    sms_consented
    phone_number
    email
    zip
    receiving_office_name
    faxed_successfully_at
    fax_metadata
    signed_at
    emailed_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    members
    exports
    driver_errors
    created_at
    updated_at
    signature
    signed_at
    email
    documents
    phone_number
    sms_consented
    consent_to_terms
    mailing_address_same_as_residential_address
    unstable_housing
    everyone_a_citizen
    anyone_disabled
    anyone_new_mom
    anyone_in_college
    anyone_living_elsewhere
    income_change
    income_change_explanation
    additional_income
    income_child_support
    income_other
    income_pension
    income_social_security
    income_ssi_or_disability
    income_unemployment_insurance
    income_workers_compensation
    rent_expense
    property_tax_expense
    insurance_expense
    utility_heat
    utility_cooling
    utility_electrity
    utility_water_sewer
    utility_trash
    utility_phone
    utility_other
    dependent_care
    medical
    court_ordered
    monthly_care_expenses
    monthly_medical_expenses
    monthly_court_ordered_expenses
    care_expenses
    medical_expenses
    court_ordered_expenses
    money_or_accounts_income
    real_estate_income
    vehicle_income
    financial_accounts
    total_money
  ].freeze

  FORM_ATTRIBUTES = %i[
    signature
    signed_at
    email
    documents
    phone_number
    sms_consented
    consent_to_terms
    mailing_address_same_as_residential_address
    unstable_housing
    everyone_a_citizen
    anyone_disabled
    anyone_new_mom
    anyone_in_college
    anyone_living_elsewhere
    income_change
    income_change_explanation
    additional_income
    income_child_support
    income_other
    income_pension
    income_social_security
    income_ssi_or_disability
    income_unemployment_insurance
    income_workers_compensation
    rent_expense
    property_tax_expense
    insurance_expense
    utility_heat
    utility_cooling
    utility_electrity
    utility_water_sewer
    utility_trash
    utility_phone
    utility_other
    dependent_care
    medical
    court_ordered
    monthly_care_expenses
    monthly_medical_expenses
    monthly_court_ordered_expenses
    care_expenses
    medical_expenses
    court_ordered_expenses
    money_or_accounts_income
    real_estate_income
    vehicle_income
    financial_accounts
    total_money
  ].freeze

  def display_resource(snap_application)
    "Snap Application ##{snap_application.id}"
  end
end
