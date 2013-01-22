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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130122121550) do

  create_table "calendars", :force => true do |t|
    t.string   "name"
    t.string   "color"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "parent_id"
    t.integer  "rgt"
    t.integer  "lft"
  end

  create_table "events", :force => true do |t|
    t.integer  "calendar_id"
    t.string   "title"
    t.text     "body"
    t.datetime "start"
    t.datetime "stop"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "recurrence_id"
  end

  create_table "recurrences", :force => true do |t|
    t.integer  "days",          :default => 0
    t.integer  "weeks",         :default => 0
    t.integer  "months",        :default => 0
    t.integer  "years",         :default => 0
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.integer  "last_event_id"
  end

end
