# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20160613144716) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.string   "entire_address"
    t.integer  "street_number"
    t.string   "street"
    t.string   "unit"
    t.integer  "zip_code"
    t.string   "state"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "assessments", force: :cascade do |t|
    t.integer  "house_id"
    t.integer  "year"
    t.integer  "land"
    t.integer  "building"
    t.integer  "assessed_total"
    t.string   "tax_exempt?"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  add_index "assessments", ["house_id"], name: "index_assessments_on_house_id", using: :btree

  create_table "houses", force: :cascade do |t|
    t.string   "address"
    t.integer  "number"
    t.string   "street"
    t.string   "street_type"
    t.integer  "zip_code"
    t.string   "unit"
    t.string   "map_number"
    t.integer  "land_area"
    t.string   "land_use"
    t.integer  "book"
    t.integer  "page"
    t.integer  "sq_ft"
    t.integer  "year_built"
    t.string   "style"
    t.integer  "bedrooms"
    t.integer  "full_baths"
    t.integer  "half_baths"
    t.integer  "fireplaces"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "owners", force: :cascade do |t|
    t.string   "name"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "middle_name"
    t.integer  "street_number"
    t.string   "street"
    t.string   "unit"
    t.integer  "zipcode"
    t.string   "state"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "pastaddresses", force: :cascade do |t|
    t.date     "date_of_information"
    t.integer  "address_id"
    t.integer  "owner_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

  add_index "pastaddresses", ["address_id"], name: "index_pastaddresses_on_address_id", using: :btree
  add_index "pastaddresses", ["owner_id"], name: "index_pastaddresses_on_owner_id", using: :btree

  create_table "pastsales", force: :cascade do |t|
    t.integer  "sale_id"
    t.integer  "owner_id"
    t.string   "transaction_side"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "pastsales", ["owner_id"], name: "index_pastsales_on_owner_id", using: :btree
  add_index "pastsales", ["sale_id"], name: "index_pastsales_on_sale_id", using: :btree

  create_table "sales", force: :cascade do |t|
    t.date     "sales_date"
    t.float    "amount"
    t.integer  "house_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "sales", ["house_id"], name: "index_sales_on_house_id", using: :btree

  create_table "summaries", force: :cascade do |t|
    t.date     "last_sale"
    t.string   "map_number"
    t.string   "owner"
    t.integer  "street_number"
    t.string   "street"
    t.string   "street_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "trials", force: :cascade do |t|
    t.date     "last_sale"
    t.string   "map_number"
    t.string   "owner"
    t.integer  "street_number"
    t.string   "street"
    t.string   "street_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

end
