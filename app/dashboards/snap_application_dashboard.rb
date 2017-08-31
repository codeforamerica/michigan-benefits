require "administrate/base_dashboard"

class SnapApplicationDashboard < Administrate::BaseDashboard
  COLLECTION_ATTRIBUTES = %i[
    id
    signature
    sms_consented
    phone_number
    email
    zip
    signed_at
    faxed_at
    fax_metadata
    created_at
    emailed_at
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

  ATTRIBUTE_TYPES = (FORM_ATTRIBUTES + SHOW_ATTRIBUTES + COLLECTION_ATTRIBUTES).
    uniq.freeze

  def display_resource(snap_application)
    "Snap Application ##{snap_application.id}"
  end
end
