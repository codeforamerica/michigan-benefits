# rubocop:disable Metrics/BlockLength
class InitSchema < ActiveRecord::Migration[5.1]
  def up
    # These are extensions that must be enabled in order to support this database
    enable_extension "plpgsql"
    create_table "addresses", force: :cascade do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "street_address", null: false
      t.string "city", null: false
      t.string "county", null: false
      t.string "state", null: false
      t.string "zip", null: false
      t.boolean "mailing", default: true, null: false
      t.bigint "snap_application_id"
      t.index ["snap_application_id"], name: "index_addresses_on_snap_application_id"
    end
    create_table "apps", id: :serial, force: :cascade do |t|
      t.string "phone_number"
      t.boolean "accepts_text_messages"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.boolean "mailing_address_same_as_home_address"
      t.string "mailing_street"
      t.string "mailing_city"
      t.string "mailing_zip"
      t.string "home_address"
      t.string "home_city"
      t.string "home_zip"
      t.boolean "unstable_housing"
      t.string "signature"
      t.string "email"
      t.date "birthday"
      t.string "marital_status"
      t.integer "household_size"
      t.boolean "income_change"
      t.text "income_change_explanation"
      t.text "additional_income", default: [], array: true
      t.boolean "everyone_a_citizen"
      t.boolean "anyone_disabled"
      t.boolean "any_new_moms"
      t.boolean "any_medical_bill_help"
      t.boolean "anyone_in_college"
      t.boolean "anyone_living_elsewhere"
      t.boolean "any_medical_bill_help_last_3_months"
      t.boolean "any_lost_insurance_last_3_months"
      t.boolean "household_tax"
      t.integer "income_child_support"
      t.boolean "has_accounts"
      t.integer "total_money"
      t.integer "rent_expense"
      t.integer "property_tax_expense"
      t.integer "insurance_expense"
      t.boolean "utility_heat"
      t.boolean "utility_cooling"
      t.boolean "utility_electrity"
      t.boolean "utility_water_sewer"
      t.boolean "utility_trash"
      t.boolean "utility_phone"
      t.boolean "utility_other"
      t.boolean "welcome_sms_sent", default: false
      t.integer "income_unemployment"
      t.integer "income_ssi"
      t.integer "income_workers_comp"
      t.integer "income_pension"
      t.integer "income_social_security"
      t.integer "income_foster_care"
      t.integer "income_other"
      t.boolean "has_home"
      t.boolean "has_vehicle"
      t.text "financial_accounts", default: [], array: true
      t.boolean "sms_reminders"
      t.boolean "email_reminders"
      t.boolean "dependent_care"
      t.boolean "medical"
      t.boolean "court_ordered"
      t.boolean "tax_deductible"
      t.integer "monthly_care_expenses"
      t.text "care_expenses", default: [], array: true
      t.integer "monthly_medical_expenses"
      t.text "medical_expenses", default: [], array: true
      t.integer "monthly_court_ordered_expenses"
      t.text "court_ordered_expenses", default: [], array: true
      t.integer "monthly_tax_deductible_expenses"
      t.text "tax_deductible_expenses", default: [], array: true
      t.string "preference_for_interview"
      t.text "additional_information"
    end
    create_table "delayed_jobs", force: :cascade do |t|
      t.integer "priority", default: 0, null: false
      t.integer "attempts", default: 0, null: false
      t.text "handler", null: false
      t.text "last_error"
      t.datetime "run_at"
      t.datetime "locked_at"
      t.datetime "failed_at"
      t.string "locked_by"
      t.string "queue"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.index ["priority", "run_at"], name: "delayed_jobs_priority"
    end
    create_table "driver_applications", force: :cascade do |t|
      t.bigint "snap_application_id", null: false
      t.string "encrypted_user_id", null: false
      t.string "encrypted_user_id_iv", null: false
      t.string "encrypted_password", null: false
      t.string "encrypted_password_iv", null: false
      t.string "encrypted_secret_question_1_answer", null: false
      t.string "encrypted_secret_question_1_answer_iv", null: false
      t.string "encrypted_secret_question_2_answer", null: false
      t.string "encrypted_secret_question_2_answer_iv", null: false
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.index ["snap_application_id"], name: "index_driver_applications_on_snap_application_id"
    end
    create_table "household_members", id: :serial, force: :cascade do |t|
      t.integer "app_id"
      t.string "first_name"
      t.string "last_name"
      t.string "sex"
      t.string "relationship"
      t.string "ssn"
      t.boolean "in_home"
      t.boolean "buy_food_with"
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.boolean "in_college"
      t.boolean "is_disabled"
      t.string "filing_status"
      t.string "employment_status"
      t.boolean "medical_help"
      t.boolean "insurance_lost_last_3_months"
      t.string "employer_name"
      t.integer "hours_per_week"
      t.integer "pay_quantity"
      t.string "pay_interval"
      t.boolean "income_consistent"
      t.string "profession"
      t.integer "monthly_pay"
      t.integer "monthly_expenses"
      t.boolean "is_citizen"
      t.boolean "is_new_mom"
      t.boolean "needs_medical_bill_help"
      t.boolean "is_living_elsewhere"
      t.integer "expected_income_this_year"
      t.integer "expected_income_next_year"
      t.index ["app_id"], name: "index_household_members_on_app_id"
    end
    create_table "members", force: :cascade do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "marital_status"
      t.string "sex"
      t.bigint "snap_application_id"
      t.string "encrypted_ssn"
      t.string "encrypted_ssn_iv"
      t.string "first_name"
      t.string "last_name"
      t.datetime "birthday"
      t.boolean "buy_food_with", default: true
      t.string "relationship"
      t.boolean "requesting_food_assistance", default: true
      t.string "employment_status"
      t.string "employed_employer_name"
      t.integer "employed_hours_per_week"
      t.integer "employed_pay_quantity"
      t.string "employed_pay_interval"
      t.string "self_employed_profession"
      t.integer "self_employed_monthly_income"
      t.string "self_employed_monthly_expenses"
      t.boolean "citizen"
      t.boolean "disabled"
      t.boolean "new_mom"
      t.boolean "in_college"
      t.boolean "living_elsewhere"
      t.index ["snap_application_id"], name: "index_members_on_snap_application_id"
    end
    create_table "snap_applications", force: :cascade do |t|
      t.datetime "created_at", null: false
      t.datetime "updated_at", null: false
      t.string "signature"
      t.datetime "signed_at"
      t.string "email"
      t.string "documents", default: [], array: true
      t.string "phone_number"
      t.boolean "sms_subscribed"
      t.boolean "consent_to_terms"
      t.boolean "mailing_address_same_as_residential_address", default: true
      t.boolean "unstable_housing", default: false
      t.boolean "everyone_a_citizen"
      t.boolean "anyone_disabled"
      t.boolean "anyone_new_mom"
      t.boolean "anyone_in_college"
      t.boolean "anyone_living_elsewhere"
      t.boolean "income_change"
      t.text "income_change_explanation"
      t.integer "rent_expense"
      t.integer "property_tax_expense"
      t.integer "insurance_expense"
      t.boolean "utility_heat"
      t.boolean "utility_cooling"
      t.boolean "utility_electrity"
      t.boolean "utility_water_sewer"
      t.boolean "utility_trash"
      t.boolean "utility_phone"
      t.boolean "utility_other"
      t.boolean "dependent_care"
      t.boolean "medical"
      t.boolean "court_ordered"
      t.integer "monthly_care_expenses"
      t.integer "monthly_medical_expenses"
      t.integer "monthly_court_ordered_expenses"
      t.string "care_expenses", default: [], array: true
      t.string "medical_expenses", default: [], array: true
      t.string "court_ordered_expenses", default: [], array: true
      t.text "additional_income", default: [], array: true
      t.integer "income_child_support"
      t.integer "income_foster_care"
      t.integer "income_other"
      t.integer "income_pension"
      t.integer "income_social_security"
      t.integer "income_ssi_or_disability"
      t.integer "income_unemployment_insurance"
      t.integer "income_workers_compensation"
      t.boolean "money_or_accounts_income"
      t.boolean "real_estate_income"
      t.boolean "vehicle_income"
      t.string "financial_accounts", default: [], array: true
      t.integer "total_money"
      t.string "interview_preference"
      t.text "additional_information"
      t.datetime "faxed_at"
    end
    add_foreign_key "driver_applications", "snap_applications"
    add_foreign_key "household_members", "apps"
  end

  def down
    raise ActiveRecord::IrreversibleMigration, "The initial migration is not revertable"
  end
end
# rubocop:enable Metrics/BlockLength
