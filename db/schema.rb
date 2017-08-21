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

ActiveRecord::Schema.define(version: 20170821164112) do

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
    t.boolean "buy_food_with"
    t.string "relationship"
    t.boolean "requesting_food_assistance", default: true
    t.string "employment_status"
    t.string "employed_employer_name"
    t.string "employed_hours_per_week"
    t.string "employed_pay_quantity"
    t.string "employed_pay_interval"
    t.string "self_employed_profession"
    t.string "self_employed_monthly_income"
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
    t.text "additional_income", default: [], array: true
    t.string "income_child_support"
    t.string "income_foster_care"
    t.string "income_other"
    t.string "income_pension"
    t.string "income_social_security"
    t.string "income_ssi_or_disability"
    t.string "income_unemployment_insurance"
    t.string "income_workers_compensation"
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
    t.boolean "money_or_accounts_income"
    t.boolean "real_estate_income"
    t.boolean "vehicle_income"
    t.string "financial_accounts", default: [], array: true
    t.integer "total_money"
  end

end
