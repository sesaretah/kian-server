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

ActiveRecord::Schema.define(version: 2021_06_09_074443) do

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
    t.integer "course_id"
    t.string "module"
    t.integer "duration"
    t.integer "asset_id"
    t.index ["principal_id"], name: "index_attendances_on_principal_id"
    t.index ["sco_id"], name: "index_attendances_on_sco_id"
    t.index ["transcript_id"], name: "index_attendances_on_transcript_id"
  end

  create_table "bb_meeting_durations", force: :cascade do |t|
    t.integer "course_id"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_bb_meeting_durations_on_course_id"
  end

  create_table "bb_meetings", force: :cascade do |t|
    t.string "record_id"
    t.integer "course_id"
    t.integer "duration"
    t.integer "number_of_participants"
    t.datetime "start_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_bb_meetings_on_course_id"
    t.index ["record_id"], name: "index_bb_meetings_on_record_id"
  end

  create_table "big_blues", force: :cascade do |t|
    t.integer "mid"
    t.integer "module_id"
    t.integer "course_id"
    t.integer "user_id"
    t.string "meeting_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mid"], name: "index_big_blues_on_mid"
  end

  create_table "course_infos", force: :cascade do |t|
    t.integer "course_id"
    t.integer "resources"
    t.integer "exams"
    t.integer "exercises"
    t.integer "number_of_sessions"
    t.integer "session_durations"
    t.float "teacher_view_mean"
    t.float "student_view_mean"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_infos_on_course_id"
  end

  create_table "course_meetings", force: :cascade do |t|
    t.integer "course_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "sco_id"
    t.index ["course_id"], name: "index_course_meetings_on_course_id"
    t.index ["sco_id"], name: "index_course_meetings_on_sco_id"
  end

  create_table "course_modules", force: :cascade do |t|
    t.integer "module_id"
    t.integer "course_id"
    t.integer "mid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "semster"
    t.index ["course_id"], name: "index_course_modules_on_course_id"
    t.index ["mid"], name: "index_course_modules_on_mid"
    t.index ["module_id"], name: "index_course_modules_on_module_id"
  end

  create_table "course_percentiles", force: :cascade do |t|
    t.float "resources"
    t.integer "course_id"
    t.float "exams"
    t.float "exercises"
    t.float "session_durations"
    t.float "teacher_view"
    t.float "student_view"
    t.float "number_of_sessions"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_percentiles_on_course_id"
  end

  create_table "course_scos", force: :cascade do |t|
    t.integer "course_id"
    t.integer "sco_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "module"
    t.index ["course_id"], name: "index_course_scos_on_course_id"
  end

  create_table "course_students", force: :cascade do |t|
    t.integer "course_id"
    t.string "fullname"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "course_teachers", force: :cascade do |t|
    t.integer "course_id"
    t.string "fullname"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
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
    t.string "uuid"
    t.index ["mid"], name: "index_courses_on_mid"
    t.index ["uuid"], name: "index_courses_on_uuid"
  end

  create_table "faculties", force: :cascade do |t|
    t.integer "serial"
    t.string "fullname"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "section"
    t.index ["section"], name: "index_faculties_on_section"
    t.index ["serial"], name: "index_faculties_on_serial"
  end

  create_table "meeting_durations", force: :cascade do |t|
    t.integer "course_id"
    t.integer "duration"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_meeting_durations_on_course_id"
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
    t.integer "module_index"
    t.index ["course_module_id"], name: "index_meetings_on_course_module_id"
    t.index ["mid"], name: "index_meetings_on_mid"
    t.index ["sco_id"], name: "index_meetings_on_sco_id"
    t.index ["start_time"], name: "index_meetings_on_start_time"
  end

  create_table "moodle_profiles", force: :cascade do |t|
    t.integer "mid"
    t.string "fullname"
    t.string "utid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mid"], name: "index_moodle_profiles_on_mid"
    t.index ["utid"], name: "index_moodle_profiles_on_utid"
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
    t.string "utid"
    t.index ["utid"], name: "index_profiles_on_utid"
  end

  create_table "roles", force: :cascade do |t|
    t.string "title"
    t.json "ability"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.boolean "default_role"
  end

  create_table "sections", force: :cascade do |t|
    t.string "title"
    t.integer "mid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["mid"], name: "index_sections_on_mid"
  end

  create_table "skopes", force: :cascade do |t|
    t.string "utid"
    t.json "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.json "sections"
    t.index ["utid"], name: "index_skopes_on_utid"
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
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.json "domains"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

end
