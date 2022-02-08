# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2022_02_08_151323) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "events", force: :cascade do |t|
    t.string "actor"
    t.string "event_type"
    t.string "repository"
    t.string "owner"
    t.json "payload", default: "{}", null: false
    t.datetime "created_at", precision: 6, null: false
    t.index ["created_at"], name: "index_events_on_created_at", using: :brin
    t.index ["repository"], name: "index_events_on_repository"
  end

  create_table "imports", force: :cascade do |t|
    t.string "filename"
    t.integer "event_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
