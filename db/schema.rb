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

ActiveRecord::Schema.define(version: 20170405222214) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: :cascade do |t|
    t.string   "phone_number"
    t.boolean  "accepts_text_messages"
    t.integer  "user_id"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.boolean  "mailing_address_same_as_home_address"
    t.string   "mailing_street"
    t.string   "mailing_city"
    t.string   "mailing_zip"
    t.string   "home_address"
    t.string   "home_city"
    t.string   "home_zip"
    t.boolean  "unstable_housing"
    t.string   "signature"
    t.string   "email"
    t.boolean  "income_change"
    t.text     "income_change_explanation"
    t.text     "additional_income",                    default: [],                 array: true
    t.date     "birthday"
    t.string   "marital_status"
    t.integer  "household_size"
    t.boolean  "everyone_a_citizen"
    t.boolean  "anyone_disabled"
    t.boolean  "any_new_moms"
    t.boolean  "any_medical_bill_help"
    t.boolean  "anyone_in_college"
    t.boolean  "anyone_living_elsewhere"
    t.boolean  "any_medical_bill_help_last_3_months"
    t.boolean  "any_lost_insurance_last_3_months"
    t.boolean  "household_tax"
    t.integer  "income_child_support"
    t.boolean  "has_accounts"
    t.integer  "total_money"
    t.integer  "rent_expense"
    t.integer  "property_tax_expense"
    t.integer  "insurance_expense"
    t.boolean  "utility_heat"
    t.boolean  "utility_cooling"
    t.boolean  "utility_electrity"
    t.boolean  "utility_water_sewer"
    t.boolean  "utility_trash"
    t.boolean  "utility_phone"
    t.boolean  "utility_other"
    t.boolean  "welcome_sms_sent",                     default: false
    t.integer  "income_unemployment"
    t.integer  "income_ssi"
    t.integer  "income_workers_comp"
    t.integer  "income_pension"
    t.integer  "income_social_security"
    t.integer  "income_foster_care"
    t.integer  "income_other"
    t.boolean  "has_home"
    t.boolean  "has_vehicle"
    t.index ["user_id"], name: "index_apps_on_user_id", using: :btree
  end

  create_table "documents", force: :cascade do |t|
    t.integer  "app_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.index ["app_id"], name: "index_documents_on_app_id", using: :btree
  end

  create_table "household_members", force: :cascade do |t|
    t.integer  "app_id"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "sex"
    t.string   "relationship"
    t.string   "ssn"
    t.boolean  "in_home"
    t.boolean  "buy_food_with"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.boolean  "in_college"
    t.boolean  "is_disabled"
    t.string   "filing_status"
    t.string   "employment_status"
    t.boolean  "medical_help"
    t.boolean  "insurance_lost_last_3_months"
    t.string   "employer_name"
    t.integer  "hours_per_week"
    t.integer  "pay_quantity"
    t.string   "pay_interval"
    t.boolean  "income_consistent"
    t.string   "profession"
    t.integer  "monthly_pay"
    t.integer  "monthly_expenses"
    t.boolean  "is_citizen"
    t.boolean  "is_new_mom"
    t.boolean  "needs_medical_bill_help"
    t.boolean  "is_living_elsewhere"
    t.integer  "expected_income_this_year"
    t.integer  "expected_income_next_year"
    t.index ["app_id"], name: "index_household_members_on_app_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                            null: false
    t.string   "crypted_password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.boolean  "admin",            default: false, null: false
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
  end

  add_foreign_key "apps", "users"
  add_foreign_key "documents", "apps"
  add_foreign_key "household_members", "apps"
end
