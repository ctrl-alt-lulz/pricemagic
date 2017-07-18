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

ActiveRecord::Schema.define(version: 20170718033954) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "metrics", force: :cascade do |t|
    t.integer  "shop_id"
    t.json     "data",       default: [],              array: true
    t.datetime "created_at",              null: false
    t.datetime "updated_at",              null: false
  end

  create_table "price_tests", force: :cascade do |t|
    t.string   "product_id"
    t.float    "percent_increase", default: 0.0
    t.float    "percent_decrease", default: 0.0
    t.jsonb    "price_data"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.boolean  "active",           default: true
  end

  add_index "price_tests", ["product_id"], name: "index_price_tests_on_product_id", using: :btree

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", null: false
    t.string   "shopify_token",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "shops", ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.text     "google_access_token"
    t.integer  "shop_id"
    t.datetime "created_at",          null: false
    t.datetime "updated_at",          null: false
  end

end
