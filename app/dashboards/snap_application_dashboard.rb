require "administrate/base_dashboard"

class SnapApplicationDashboard < Administrate::BaseDashboard
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    signature: Field::String,
    signed_at: Field::DateTime,
    email: Field::String,
    documents: Field::String,
    phone_number: Field::String,
    sms_subscribed: Field::Boolean,
    consent_to_terms: Field::Boolean,
    mailing_address_same_as_residential_address: Field::Boolean,
    unstable_housing: Field::Boolean,
    everyone_a_citizen: Field::Boolean,
    anyone_disabled: Field::Boolean,
    anyone_new_mom: Field::Boolean,
    anyone_in_college: Field::Boolean,
    anyone_living_elsewhere: Field::Boolean,
    income_change: Field::Boolean,
    income_change_explanation: Field::Text,
    additional_income: Field::Text,
    income_child_support: Field::String,
    income_foster_care: Field::String,
    income_other: Field::String,
    income_pension: Field::String,
    income_social_security: Field::String,
    income_ssi_or_disability: Field::String,
    income_unemployment_insurance: Field::String,
    income_workers_compensation: Field::String,
    rent_expense: Field::Number,
    property_tax_expense: Field::Number,
    insurance_expense: Field::Number,
    utility_heat: Field::Boolean,
    utility_cooling: Field::Boolean,
    utility_electrity: Field::Boolean,
    utility_water_sewer: Field::Boolean,
    utility_trash: Field::Boolean,
    utility_phone: Field::Boolean,
    utility_other: Field::Boolean,
    dependent_care: Field::Boolean,
    medical: Field::Boolean,
    court_ordered: Field::Boolean,
    monthly_care_expenses: Field::Number,
    monthly_medical_expenses: Field::Number,
    monthly_court_ordered_expenses: Field::Number,
    care_expenses: Field::String,
    medical_expenses: Field::String,
    court_ordered_expenses: Field::String,
    money_or_accounts_income: Field::Boolean,
    real_estate_income: Field::Boolean,
    vehicle_income: Field::Boolean,
    financial_accounts: Field::String,
    total_money: Field::Number,
  }.freeze

  COLLECTION_ATTRIBUTES = %i[
    id
    email
    phone_number
    created_at
  ].freeze

  SHOW_PAGE_ATTRIBUTES = %i[
    id
    created_at
    updated_at
    signature
    signed_at
    email
    documents
    phone_number
    sms_subscribed
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
    income_foster_care
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
    sms_subscribed
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
    income_foster_care
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
