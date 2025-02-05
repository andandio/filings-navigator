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

ActiveRecord::Schema[7.0].define(version: 2023_10_30_192822) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "awards", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "grantmaker_id", null: false
    t.bigint "recipient_id"
    t.bigint "filing_id", null: false
    t.text "purpose"
    t.decimal "cash_award", precision: 10, scale: 2
    t.index ["filing_id"], name: "index_awards_on_filing_id"
  end

  create_table "filers", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "ein"
    t.string "name"
    t.string "address"
    t.string "city"
    t.string "state"
    t.string "zip"
    t.index ["ein", "name", "zip"], name: "index_filers_on_ein_and_name_and_zip", unique: true
  end

  create_table "filings", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "filer_id", null: false
    t.boolean "amended_indicator"
    t.datetime "filed_at"
    t.string "tax_period_end_at"
    t.index ["filer_id"], name: "index_filings_on_filer_id"
  end

  add_foreign_key "awards", "filers", column: "grantmaker_id"
  add_foreign_key "awards", "filers", column: "recipient_id"
  add_foreign_key "awards", "filings"
  add_foreign_key "filings", "filers"
end
