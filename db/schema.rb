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

ActiveRecord::Schema.define(version: 20160518015355) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "assessments", force: :cascade do |t|
    t.integer  "year"
    t.integer  "land"
    t.integer  "building"
    t.integer  "assessed_total"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
  end

  create_table "houses", force: :cascade do |t|
    t.integer  "number"
    t.string   "street"
    t.string   "street_type"
    t.integer  "zip_code"
    t.string   "unit"
    t.string   "owner_first_name"
    t.string   "owner_last_name"
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
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "sales", force: :cascade do |t|
    t.date     "date"
    t.float    "amount"
    t.string   "seller"
    t.string   "buyer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end