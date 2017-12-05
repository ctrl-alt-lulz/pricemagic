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

ActiveRecord::Schema.define(version: 20171205042122) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "charges", force: :cascade do |t|
    t.string   "type"
    t.integer  "shopify_id"
    t.integer  "shop_id"
    t.integer  "user_id"
    t.jsonb    "charge_data"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "collections", force: :cascade do |t|
    t.string   "title"
    t.string   "shopify_collection_id"
    t.string   "collection_type"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "shop_id"
  end

  create_table "collects", force: :cascade do |t|
    t.string   "position"
    t.string   "shopify_collect_id"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "collection_id"
    t.integer  "product_id"
  end

  create_table "metrics", force: :cascade do |t|
    t.integer  "shop_id"
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "product_id"
    t.integer  "variant_id"
    t.string   "page_title"
    t.float    "page_revenue"
    t.integer  "page_views"
    t.float    "page_avg_price"
    t.datetime "acquired_at"
  end

  create_table "price_tests", force: :cascade do |t|
    t.float    "percent_increase",         default: 0.0
    t.float    "percent_decrease",         default: 0.0
    t.jsonb    "price_data"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.boolean  "active",                   default: true
    t.float    "ending_digits",            default: 0.99
    t.integer  "price_points",             default: 0
    t.integer  "product_id"
    t.datetime "current_price_started_at"
    t.integer  "view_threshold"
  end

  create_table "products", force: :cascade do |t|
    t.string   "title"
    t.string   "shopify_product_id"
    t.string   "product_type"
    t.string   "tags"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "shop_id"
    t.string   "main_image_src"
  end

  create_table "shops", force: :cascade do |t|
    t.string   "shopify_domain", null: false
    t.string   "shopify_token",  null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shop_email"
  end

  add_index "shops", ["shopify_domain"], name: "index_shops_on_shopify_domain", unique: true, using: :btree

  create_table "site_admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "site_admins", ["email"], name: "index_site_admins_on_email", unique: true, using: :btree
  add_index "site_admins", ["reset_password_token"], name: "index_site_admins_on_reset_password_token", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.text     "google_access_token"
    t.integer  "shop_id"
    t.datetime "created_at",           null: false
    t.datetime "updated_at",           null: false
    t.text     "google_refresh_token"
    t.string   "google_profile_id"
  end

  create_table "variants", force: :cascade do |t|
    t.integer  "product_id"
    t.string   "shopify_product_id"
    t.string   "shopify_variant_id"
    t.string   "variant_title"
    t.string   "variant_price"
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
    t.float    "unit_cost",          default: 0.0
  end

end
