# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171106225616) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string "city", null: false
    t.string "county", null: false
    t.datetime "created_at", null: false
    t.boolean "mailing", default: true, null: false
    t.bigint "snap_application_id"
    t.string "state", null: false
    t.string "street_address", null: false
    t.datetime "updated_at", null: false
    t.string "zip", null: false
    t.index ["snap_application_id"], name: "index_addresses_on_snap_application_id"
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "current_sign_in_at"
    t.inet "current_sign_in_ip"
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "last_sign_in_at"
    t.inet "last_sign_in_ip"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "attempts", default: 0, null: false
    t.datetime "created_at"
    t.datetime "failed_at"
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "locked_at"
    t.string "locked_by"
    t.integer "priority", default: 0, null: false
    t.string "queue"
    t.datetime "run_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "driver_applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "driven_at", null: false
    t.string "encrypted_password", null: false
    t.string "encrypted_password_iv", null: false
    t.string "encrypted_secret_question_1_answer", null: false
    t.string "encrypted_secret_question_1_answer_iv", null: false
    t.string "encrypted_secret_question_2_answer", null: false
    t.string "encrypted_secret_question_2_answer_iv", null: false
    t.string "encrypted_user_id", null: false
    t.string "encrypted_user_id_iv", null: false
    t.bigint "snap_application_id", null: false
    t.string "tracking_number"
    t.datetime "updated_at", null: false
    t.index ["snap_application_id"], name: "index_driver_applications_on_snap_application_id"
  end

  create_table "driver_errors", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "driven_at", null: false
    t.bigint "driver_application_id", null: false
    t.string "error_class", null: false
    t.string "error_message", null: false
    t.string "page_class", null: false
    t.text "page_html", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_application_id"], name: "index_driver_errors_on_driver_application_id"
  end

  create_table "exports", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.string "destination"
    t.boolean "force", default: false
    t.string "metadata"
    t.bigint "snap_application_id"
    t.string "status", default: "new"
    t.datetime "updated_at", null: false
    t.index ["snap_application_id"], name: "index_exports_on_snap_application_id"
  end

  create_table "medicaid_applications", force: :cascade do |t|
    t.boolean "anyone_caretaker_or_parent"
    t.boolean "anyone_disabled"
    t.boolean "anyone_employed"
    t.boolean "anyone_in_college"
    t.boolean "anyone_insured", default: false
    t.boolean "anyone_new_mom"
    t.boolean "anyone_other_income", default: false
    t.boolean "anyone_pay_child_support_alimony_arrears"
    t.boolean "anyone_pay_student_loan_interest"
    t.boolean "anyone_self_employed", default: false
    t.datetime "birthday"
    t.integer "child_support_alimony_arrears_expenses"
    t.integer "college_loan_interest_expenses"
    t.boolean "consent_to_terms"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "employed_monthly_income", default: [], array: true
    t.string "encrypted_last_four_ssn"
    t.string "encrypted_last_four_ssn_iv"
    t.boolean "everyone_a_citizen"
    t.boolean "filing_federal_taxes_next_year"
    t.boolean "flint_water_crisis"
    t.boolean "homeless"
    t.boolean "income_alimony"
    t.boolean "income_pension"
    t.boolean "income_retirement"
    t.boolean "income_social_security"
    t.boolean "income_unemployment"
    t.boolean "mail_sent_to_residential"
    t.boolean "mailing_address_same_as_residential_address", default: true
    t.string "mailing_city"
    t.string "mailing_street_address"
    t.string "mailing_zip"
    t.boolean "michigan_resident", null: false
    t.boolean "need_medical_expense_help_3_months"
    t.string "office_location"
    t.string "paperwork", array: true
    t.string "phone_number"
    t.boolean "reliable_mail_address"
    t.string "residential_city"
    t.string "residential_street_address"
    t.string "residential_zip"
    t.integer "self_employed_monthly_income"
    t.integer "self_employment_expenses"
    t.string "signature"
    t.datetime "signed_at"
    t.boolean "sms_consented", default: true
    t.string "sms_phone_number"
    t.boolean "submit_ssn"
    t.integer "unemployment_income"
    t.datetime "updated_at", null: false
    t.boolean "upload_paperwork"
  end

  create_table "members", force: :cascade do |t|
    t.bigint "benefit_application_id", null: false
    t.string "benefit_application_type", null: false
    t.datetime "birthday"
    t.boolean "buy_food_with", default: true
    t.boolean "caretaker_or_parent", default: false
    t.boolean "citizen"
    t.datetime "created_at", null: false
    t.boolean "disabled"
    t.boolean "employed", default: false
    t.string "employed_employer_name"
    t.integer "employed_hours_per_week"
    t.string "employed_monthly_income", default: [], array: true
    t.integer "employed_number_of_jobs"
    t.string "employed_pay_interval"
    t.integer "employed_pay_quantity"
    t.string "employment_status"
    t.string "encrypted_last_four_ssn"
    t.string "encrypted_last_four_ssn_iv"
    t.string "first_name"
    t.boolean "in_college"
    t.string "insurance_type"
    t.boolean "insured", default: false
    t.string "last_name"
    t.boolean "living_elsewhere"
    t.string "marital_status"
    t.boolean "new_mom"
    t.boolean "other_income", default: false
    t.string "other_income_types", default: [], array: true
    t.boolean "pay_child_support_alimony_arrears"
    t.boolean "pay_student_loan_interest"
    t.string "relationship"
    t.boolean "requesting_food_assistance", default: true
    t.boolean "requesting_health_insurance", default: true
    t.boolean "self_employed", default: false
    t.string "self_employed_monthly_expenses"
    t.integer "self_employed_monthly_income"
    t.string "self_employed_profession"
    t.string "sex"
    t.datetime "updated_at", null: false
  end

  create_table "snap_applications", force: :cascade do |t|
    t.text "additional_income", default: [], array: true
    t.text "additional_information"
    t.boolean "anyone_disabled"
    t.boolean "anyone_in_college"
    t.boolean "anyone_living_elsewhere"
    t.boolean "anyone_new_mom"
    t.string "care_expenses", default: [], array: true
    t.boolean "consent_to_terms"
    t.boolean "court_ordered"
    t.string "court_ordered_expenses", default: [], array: true
    t.datetime "created_at", null: false
    t.boolean "dependent_care"
    t.string "documents", default: [], array: true
    t.string "email"
    t.boolean "everyone_a_citizen"
    t.string "financial_accounts", default: [], array: true
    t.boolean "income_change"
    t.text "income_change_explanation"
    t.integer "income_child_support"
    t.integer "income_other"
    t.integer "income_pension"
    t.integer "income_social_security"
    t.integer "income_ssi_or_disability"
    t.integer "income_unemployment_insurance"
    t.integer "income_workers_compensation"
    t.integer "insurance_expense"
    t.boolean "mailing_address_same_as_residential_address", default: true
    t.boolean "medical"
    t.string "medical_expenses", default: [], array: true
    t.boolean "money_or_accounts_income"
    t.integer "monthly_care_expenses"
    t.integer "monthly_court_ordered_expenses"
    t.integer "monthly_medical_expenses"
    t.string "office_location"
    t.string "phone_number"
    t.integer "property_tax_expense"
    t.boolean "real_estate_income"
    t.integer "rent_expense"
    t.string "signature"
    t.datetime "signed_at"
    t.boolean "sms_consented"
    t.integer "total_money"
    t.boolean "unstable_housing", default: false
    t.datetime "updated_at", null: false
    t.boolean "utility_cooling"
    t.boolean "utility_electrity"
    t.boolean "utility_heat"
    t.boolean "utility_other"
    t.boolean "utility_phone"
    t.boolean "utility_trash"
    t.boolean "utility_water_sewer"
    t.boolean "vehicle_income"
  end

  add_foreign_key "driver_applications", "snap_applications"
  add_foreign_key "driver_errors", "driver_applications"
end
