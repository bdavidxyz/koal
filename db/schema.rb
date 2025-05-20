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

ActiveRecord::Schema[8.0].define(version: 2025_04_23_063028) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "rabarber_roles", force: :cascade do |t|
    t.string "name", null: false
    t.string "context_type"
    t.bigint "context_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["context_type", "context_id"], name: "index_rabarber_roles_on_context"
    t.index ["name", "context_type", "context_id"], name: "index_rabarber_roles_on_name_and_context_type_and_context_id", unique: true
  end

  create_table "rabarber_roles_roleables", id: false, force: :cascade do |t|
    t.bigint "role_id", null: false
    t.bigint "roleable_id", null: false
    t.index ["role_id", "roleable_id"], name: "index_rabarber_roles_roleables_on_role_id_and_roleable_id", unique: true
    t.index ["role_id"], name: "index_rabarber_roles_roleables_on_role_id"
    t.index ["roleable_id"], name: "index_rabarber_roles_roleables_on_roleable_id"
  end

  create_table "sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "user_agent"
    t.string "ip_address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_sessions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "slug"
    t.string "name"
    t.boolean "verified", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "rabarber_roles_roleables", "rabarber_roles", column: "role_id"
  add_foreign_key "rabarber_roles_roleables", "users", column: "roleable_id"
  add_foreign_key "sessions", "users"
end
