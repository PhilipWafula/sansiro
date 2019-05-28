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

ActiveRecord::Schema.define(version: 2019_05_28_152406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "admin_tips", force: :cascade do |t|
    t.string "tip_content"
    t.string "tip_package"
    t.date "tip_date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "admin_id"
    t.index ["admin_id"], name: "index_admin_tips_on_admin_id"
  end

  create_table "admins", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_admins_on_confirmation_token", unique: true
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_admins_on_unlock_token", unique: true
  end

  create_table "api_responses", force: :cascade do |t|
    t.string "request_identifier", null: false
    t.string "type"
    t.string "status", null: false
    t.string "status_description"
    t.string "response_code"
    t.string "recipient_phone_number"
  end

  create_table "mpesa_transactions", force: :cascade do |t|
    t.string "service_name"
    t.decimal "business_number"
    t.string "transaction_reference"
    t.decimal "k2_transaction_id"
    t.datetime "transaction_timestamp"
    t.string "transaction_type"
    t.decimal "transaction_sender_phone"
    t.string "first_name"
    t.string "middle_name"
    t.string "last_name"
    t.decimal "transaction_amount"
    t.string "transaction_currency"
    t.string "transaction_signature"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subscription_package"
  end

  add_foreign_key "admin_tips", "admins"
end
