# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.1].define(version: 2026_05_06_233153) do
  create_table "plans", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "features"
    t.string "interval"
    t.string "name"
    t.integer "price_cents"
    t.datetime "updated_at", null: false
  end

  create_table "receipts", force: :cascade do |t|
    t.integer "amount"
    t.integer "amount_cents", null: false
    t.datetime "created_at", null: false
    t.string "currency", default: "usd", null: false
    t.string "email"
    t.string "name"
    t.integer "plan_id", null: false
    t.string "plan_name"
    t.string "stripe_session_id", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.index ["plan_id"], name: "index_receipts_on_plan_id"
    t.index ["stripe_session_id"], name: "index_receipts_on_stripe_session_id", unique: true
    t.index ["user_id"], name: "index_receipts_on_user_id"
  end

  create_table "solid_cache_entries", force: :cascade do |t|
    t.integer "byte_size"
    t.datetime "created_at", null: false
    t.datetime "expires_at"
    t.bigint "key_hash", null: false
    t.binary "value"
    t.index ["key_hash", "byte_size"], name: "index_solid_cache_entries_on_key_hash_and_byte_size"
    t.index ["key_hash"], name: "index_solid_cache_entries_on_key_hash", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "receipts", "plans"
  add_foreign_key "receipts", "users"
end
