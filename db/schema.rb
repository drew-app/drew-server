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

ActiveRecord::Schema.define(version: 2019_07_08_224633) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "name"], name: "index_tags_on_user_id_and_name", unique: true
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "tags_tasks", id: false, force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.bigint "task_id", null: false
  end

  create_table "tasks", force: :cascade do |t|
    t.string "title"
    t.boolean "done", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "focused", default: false
    t.text "description"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "tracker_records", force: :cascade do |t|
    t.bigint "tracker_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tracker_id"], name: "index_tracker_records_on_tracker_id"
  end

  create_table "trackers", force: :cascade do |t|
    t.string "title"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_trackers_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "nickname"
    t.string "email"
    t.string "avatar_url"
    t.json "token_details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "tags", "users"
  add_foreign_key "tasks", "users"
  add_foreign_key "tracker_records", "trackers"
  add_foreign_key "trackers", "users"
end
