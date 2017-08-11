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

ActiveRecord::Schema.define(version: 20170811162824) do

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
    t.string "marital_status", null: false
    t.string "sex", null: false
    t.bigint "snap_application_id"
    t.string "encrypted_ssn"
    t.string "encrypted_ssn_iv"
    t.index ["snap_application_id"], name: "index_members_on_snap_application_id"
  end

  create_table "snap_applications", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.date "birthday"
    t.string "signature"
    t.datetime "signed_at"
    t.string "email"
    t.string "documents", default: [], array: true
    t.string "phone_number"
    t.boolean "sms_subscribed"
    t.boolean "consent_to_terms"
    t.boolean "mailing_address_same_as_residential_address"
    t.boolean "unstable_housing", default: false
  end

end
