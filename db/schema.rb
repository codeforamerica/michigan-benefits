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

ActiveRecord::Schema.define(version: 20170329192315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apps", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
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
    t.boolean  "unstable_housing",                     default: false
    t.string   "signature"
    t.string   "email"
    t.boolean  "income_change"
    t.text     "income_change_explanation"
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
end
