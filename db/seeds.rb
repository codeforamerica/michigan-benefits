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
  mailing_address_same_as_residential_address: false,
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
  benefit_application: minimal_application,
  first_name: "Test",
  last_name: "Client",
)

minimal_primary.update!(
  marital_status: "Never married",
  sex: "male",
  encrypted_ssn: "UdGpZ8L9KTaTjsjOtT9F3He/AtUaxIz2EQ==\n",
  encrypted_ssn_iv: "Y6bSPA1stu3NXxn7\n",
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
  care_expenses: SnapApplication::CARE_EXPENSES,
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
  benefit_application: complete_application,
  first_name: "Complete",
  last_name: "Testapp",
)

complete_primary.update!(
  marital_status: "Married",
  sex: "male",
  benefit_application_id: 2,
  encrypted_ssn: "ujHTFrdIDQe9yP0ridG6lbInC2B55epElw==\n",
  encrypted_ssn_iv: "a7xXqiBGgWMLlZLU\n",
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
  benefit_application: complete_application,
  first_name: "Jane",
  last_name: "Doe",
)

complete_second_member.update!(
  marital_status: "Married",
  sex: "female",
  encrypted_ssn: "TYSEI32VMGSr25smRwriVd7TYdHjgF+vXg==\n",
  encrypted_ssn_iv: "eDQLj3SgLkha2LqC\n",
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
  benefit_application: complete_application,
  first_name: "Random",
  last_name: "Roommate",
)

complete_third_member.update!(
  marital_status: "Never married",
  sex: "female",
  encrypted_ssn: "MojSW2g8R/3/qoYwBNJe+GOfbgtUUnCxFw==\n",
  encrypted_ssn_iv: "MqnvVY9uetY43os2\n",
  birthday: 16.years.ago,
  buy_food_with: true,
  relationship: "Roommate",
  requesting_food_assistance: true,
  employment_status: "self_employed",
  self_employed_profession: "Marketing",
  self_employed_monthly_income: 800,
  self_employed_monthly_expenses: "400",
)

complete_application.
  exports.
  where(destination: :fax).
  first_or_initialize(
    metadata: "Faxed to Michigan Benefits (+15551112345)",
    force: false,
    status: :succeeded,
    completed_at: Time.current,
  ).save

complete_application.
  exports.
  where(destination: :client_email).
  first_or_initialize(
    metadata: "I, [2017-10-10T14:29:39.397443 #4]  INFO -- : [ActiveJob] "\
      "[ClientEmailApplicationJob] [1c8d2c86-34f3-48ea-96be-88cf2fee9786] "\
      "Emailed to #{complete_application.email}\n",
    force: false,
    status: :succeeded,
    completed_at: Time.current,
  ).save

complete_application.
  exports.
  where(destination: :office_email).
  first_or_initialize(
    metadata: "",
    force: false,
    status: :succeeded,
    completed_at: Time.current,
  ).save

puts "More complete application created (or found) " \
  "with id: #{complete_application.id}"

puts "Creating a minimal medicaid application..."

medicaid_application = MedicaidApplication.find_or_initialize_by(
  email: "medicaid.application@example.com",
)

medicaid_application.update!(
  michigan_resident: true,
)

medicaid_primary = Member.find_or_initialize_by(
  benefit_application: medicaid_application,
  first_name: "Medicaid",
  last_name: "TestPerson",
)

medicaid_primary.update!(
  sex: "female",
)

puts "Minimal medicaid application created (or found) " \
  "with id: #{medicaid_application.id}"

puts "Creating a more complete medicaid application..."

complete_medicaid_application = MedicaidApplication.find_or_initialize_by(
  email: "medicaid.application2@example.com",
)
complete_medicaid_application.update!(
  michigan_resident: true,
  anyone_insured: true,
  unemployment_income: 100,
)

complete_medicaid_primary = Member.find_or_initialize_by(
  benefit_application: medicaid_application,
  first_name: "CompleteMedicaid",
  last_name: "TestPerson",
  sex: "female",
)

complete_medicaid_primary.update!(
  insured: true,
  insurance_type: "VA health care programs",
)

complete_medicaid_secondary = Member.find_or_initialize_by(
  benefit_application: medicaid_application,
  first_name: "CompleteMedicaid2",
  last_name: "TestPerson",
  sex: "male",
)

complete_medicaid_application.update!(
  members: [
    complete_medicaid_primary,
    complete_medicaid_secondary,
  ],
)

puts "A more complete medicaid application created (or found) " \
  "with id: #{complete_medicaid_application.id}"
