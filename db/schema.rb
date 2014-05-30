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

ActiveRecord::Schema.define(version: 20140530120126) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bread_types", force: true do |t|
    t.text     "name"
    t.boolean  "sour_dough"
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "collection_points", force: true do |t|
    t.text     "address"
    t.text     "post_code"
    t.text     "notes"
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribers", force: true do |t|
    t.string   "name"
    t.text     "address"
    t.string   "phone"
    t.integer  "collection_point_id"
    t.date     "start_date"
    t.date     "paid_until"
    t.integer  "bread_type_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.text     "notes"
    t.integer  "stripe_customer_id"
  end

  add_index "subscribers", ["bread_type_id"], name: "index_subscribers_on_bread_type_id", using: :btree
  add_index "subscribers", ["collection_point_id"], name: "index_subscribers_on_collection_point_id", using: :btree
  add_index "subscribers", ["email"], name: "index_subscribers_on_email", unique: true, using: :btree
  add_index "subscribers", ["reset_password_token"], name: "index_subscribers_on_reset_password_token", unique: true, using: :btree

end
