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

ActiveRecord::Schema.define(version: 20150807013427) do

  create_table "folders", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "parent_folder_id"
    t.string   "name"
    t.string   "description"
    t.boolean  "published"
    t.integer  "download_count"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  create_table "memories", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "folder_id"
    t.string   "title"
    t.string   "subtitle"
    t.string   "text"
    t.string   "source"
    t.date     "start_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "memory_days", force: :cascade do |t|
    t.integer  "memory_id"
    t.date     "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "reminders", force: :cascade do |t|
    t.integer  "memory_id"
    t.integer  "priority"
    t.integer  "time_unit_id"
    t.integer  "time_unit_quantity"
    t.integer  "repeat_quantity"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  create_table "time_units", force: :cascade do |t|
    t.string "unit"
  end

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

end
