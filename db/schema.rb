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

ActiveRecord::Schema.define(version: 20140529150801) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

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
  end

  add_index "subscribers", ["bread_type_id"], name: "index_subscribers_on_bread_type_id", using: :btree
  add_index "subscribers", ["collection_point_id"], name: "index_subscribers_on_collection_point_id", using: :btree

end
