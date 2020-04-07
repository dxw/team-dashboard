# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_04_07_150339) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"

  create_table "assignments", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "project_id"
    t.bigint "team_member_id"
    t.index ["project_id"], name: "index_assignments_on_project_id"
    t.index ["team_member_id"], name: "index_assignments_on_team_member_id"
  end

  create_table "projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "starts_at"
    t.string "ends_at"
    t.string "client"
    t.boolean "archived"
    t.integer "tenk_id", null: false
  end

  create_table "team_members", force: :cascade do |t|
    t.uuid "project_id"
    t.integer "tenk_id", null: false
    t.string "discipline"
    t.string "thumbnail"
    t.boolean "billable"
    t.string "first_name"
    t.string "last_name"
    t.index ["project_id"], name: "index_team_members_on_project_id"
  end

end
