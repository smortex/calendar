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

ActiveRecord::Schema.define(version: 20130606103225) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "calendars", force: true do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "parent_id"
    t.integer  "rgt"
    t.integer  "lft"
    t.integer  "default_fb", default: 1
  end

  create_table "events", force: true do |t|
    t.integer  "calendar_id"
    t.string   "title"
    t.text     "body"
    t.datetime "start"
    t.datetime "stop"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "recurrence_id"
    t.integer  "fb"
  end

  create_table "recurrences", force: true do |t|
    t.integer  "days",          default: 0
    t.integer  "weeks",         default: 0
    t.integer  "months",        default: 0
    t.integer  "years",         default: 0
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "last_event_id"
  end

  create_table "versions", force: true do |t|
    t.string   "item_type",  null: false
    t.integer  "item_id",    null: false
    t.string   "event",      null: false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
  end

  add_index "versions", ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id", using: :btree

end
