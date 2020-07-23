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

ActiveRecord::Schema.define(version: 2020_07_23_141807) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "attendances", force: :cascade do |t|
    t.integer "principal_id"
    t.integer "sco_id"
    t.integer "transcript_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "start_time"
    t.datetime "end_time"
    t.index ["principal_id"], name: "index_attendances_on_principal_id"
    t.index ["sco_id"], name: "index_attendances_on_sco_id"
    t.index ["transcript_id"], name: "index_attendances_on_transcript_id"
  end

  create_table "course_modules", force: :cascade do |t|
    t.integer "module_id"
    t.integer "course_id"
    t.integer "mid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_modules_on_course_id"
    t.index ["mid"], name: "index_course_modules_on_mid"
    t.index ["module_id"], name: "index_course_modules_on_module_id"
  end

  create_table "course_scos", force: :cascade do |t|
    t.integer "course_id"
    t.integer "sco_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_scos_on_course_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.string "serial"
    t.integer "mid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "faculty_id"
    t.integer "group_id"
    t.integer "semster"
    t.index ["mid"], name: "index_courses_on_mid"
  end

  create_table "meetings", force: :cascade do |t|
    t.integer "course_module_id"
    t.integer "sco_id"
    t.integer "adobe_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "mid"
    t.index ["course_module_id"], name: "index_meetings_on_course_module_id"
    t.index ["mid"], name: "index_meetings_on_mid"
    t.index ["sco_id"], name: "index_meetings_on_sco_id"
  end

  create_table "principals", force: :cascade do |t|
    t.string "name"
    t.integer "principal_id"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["principal_id"], name: "index_principals_on_principal_id"
  end

  create_table "profiles", force: :cascade do |t|
    t.string "name"
    t.string "surename"
    t.string "mobile"
    t.text "bio"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
  end

  create_table "roles", force: :cascade do |t|
    t.string "title"
    t.json "ability"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "default_role"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "assignments"
    t.string "last_code"
    t.datetime "last_code_datetime"
    t.datetime "last_login"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
