# frozen_string_literal: true

puts "Creating minimal snap application..."

minimal_application = SnapApplication.find_or_initialize_by(
  email: "minimal.application@example.com",
)

minimal_application.update!(
  signature: "Minimal Application",
  signed_at: Time.current,
  phone_number: "5551230000",
  sms_consented: false,
  consent_to_terms: true,
  everyone_a_citizen: true,
  anyone_disabled: false,
  anyone_new_mom: false,
  anyone_in_college: false,
  anyone_living_elsewhere: false,
  income_change: false,
  rent_expense: 500,
  property_tax_expense: 0,
  insurance_expense: 0,
  utility_heat: false,
  utility_cooling: false,
  utility_electrity: false,
  utility_water_sewer: false,
  utility_trash: false,
  utility_phone: false,
  utility_other: false,
  dependent_care: false,
  medical: false,
  court_ordered: false,
  money_or_accounts_income: false,
  real_estate_income: false,
  vehicle_income: false,
  unstable_housing: true,
  mailing_address_same_as_residential_address: true,
)

minimal_mailing = Address.find_or_initialize_by(
  snap_application: minimal_application,
)

minimal_mailing.update!(
  street_address: "123 Main St.",
  city: "Flint",
  zip: "12345",
  county: "Genesee",
  state: "MI",
  mailing: true,
)

minimal_primary = Member.find_or_initialize_by(
  snap_application: minimal_application,
  first_name: "Test",
  last_name: "Client",
)

minimal_primary.update!(
  marital_status: "Never married",
  sex: "male",
  encrypted_ssn: "D0zKx2AZL9zkT9acqR9a5NDbxmL9c3cNgQ==\n",
  encrypted_ssn_iv: "zlSjtIuRh4/T4gHe\n",
  birthday: 30.years.ago,
  employment_status: "not_employed",
)

puts "Minimal application created (or found) with id: #{minimal_application.id}"

puts "Creating a more complete snap application..."

flint_driver_license =
  "https://shubox-codepen-io.s3.amazonaws.com/s-codepen-io/7d1a2bc9/id.jpg"

complete_application = SnapApplication.find_or_initialize_by(
  email: "complete.application@example.com",
)

complete_application.update!(
  signature: "Complete Testapp",
  signed_at: Time.current,
  documents: [flint_driver_license],
  phone_number: "5550001234",
  sms_consented: true,
  consent_to_terms: true,
  mailing_address_same_as_residential_address: false,
  unstable_housing: true,
  everyone_a_citizen: true,
  anyone_disabled: false,
  anyone_new_mom: false,
  anyone_in_college: false,
  anyone_living_elsewhere: false,
  income_change: true,
  income_change_explanation: "Someone got a new job.",
  additional_income: [
    "other",
    "pension",
    "ssi_or_disability",
    "workers_compensation",
    "unemployment_insurance",
  ],
  income_other: 11,
  income_pension: 22,
  income_ssi_or_disability: 33,
  income_workers_compensation: 44,
  income_unemployment_insurance: 55,
  rent_expense: 400,
  property_tax_expense: 100,
  insurance_expense: 100,
  utility_heat: true,
  utility_cooling: false,
  utility_electrity: false,
  utility_water_sewer: true,
  utility_trash: false,
  utility_phone: true,
  utility_other: false,
  dependent_care: true,
  medical: true,
  court_ordered: false,
  monthly_care_expenses: 400,
  monthly_medical_expenses: 200,
  monthly_court_ordered_expenses: nil,
  care_expenses: ["childcare"],
  medical_expenses: SnapApplication::MEDICAL_EXPENSES,
  money_or_accounts_income: true,
  real_estate_income: true,
  vehicle_income: true,
  financial_accounts: ["checking_account", "four_oh_one_k"],
  total_money: 2000,
  additional_information: "N/A",
)

complete_mailing = Address.find_or_initialize_by(
  snap_application: complete_application,
  street_address: "1 Fuller Ave.",
)

complete_mailing.update!(
  city: "Flint",
  county: "Genesee",
  state: "MI",
  zip: "48503",
  mailing: true,
)

complete_residential = Address.find_or_initialize_by(
  snap_application: complete_application,
  street_address: "100 Home St.",
)

complete_residential.update!(
  city: "Flint",
  county: "Genesee",
  state: "MI",
  zip: "48503",
  mailing: false,
)

complete_primary = Member.find_or_initialize_by(
  snap_application: complete_application,
  first_name: "Complete",
  last_name: "Testapp",
)

complete_primary.update!(
  marital_status: "Married",
  sex: "male",
  snap_application_id: 2,
  encrypted_ssn: "lWqpXtZV/j8XV8+Ci/0H6ZFYt5MXwp+TJA==\n",
  encrypted_ssn_iv: "Y9G6b8hj2mmDi4Uv\n",
  birthday: 40.years.ago,
  buy_food_with: true,
  relationship: "Spouse",
  requesting_food_assistance: true,
  employment_status: "employed",
  employed_employer_name: "Programmer",
  employed_hours_per_week: 32,
  employed_pay_quantity: 800,
  employed_pay_interval: "Weekly",
)

complete_second_member = Member.find_or_initialize_by(
  snap_application: complete_application,
  first_name: "Jane",
  last_name: "Doe",
)

complete_second_member.update!(
  marital_status: "Married",
  sex: "female",
  encrypted_ssn: "VmZuoPhyIRTXCu2gGOqTmgz54wgfNEemYg==\n",
  encrypted_ssn_iv: "kdIzFUg+2U/gM9wE\n",
  birthday: 36.years.ago,
  buy_food_with: true,
  relationship: "Spouse",
  requesting_food_assistance: true,
  employment_status: "self_employed",
  self_employed_profession: "Marketing",
  self_employed_monthly_income: 800,
  self_employed_monthly_expenses: "400",
)

complete_third_member = Member.find_or_initialize_by(
  snap_application: complete_application,
  first_name: "Random",
  last_name: "Roommate",
)

complete_third_member.update!(
  marital_status: "Never married",
  sex: "female",
  encrypted_ssn: "VhzEa7Hee+IXOdIBwjhPL0vB/OTqR4fe1TIi\n",
  encrypted_ssn_iv: "F7Gz/ujIHfhZuhoY\n",
  birthday: 16.years.ago,
  buy_food_with: true,
  relationship: "Roommate",
  requesting_food_assistance: true,
  employment_status: "self_employed",
  self_employed_profession: "Marketing",
  self_employed_monthly_income: 800,
  self_employed_monthly_expenses: "400",
)

puts "More complete application created (or found) " \
  "with id: #{complete_application.id}"
