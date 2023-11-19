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

ActiveRecord::Schema[7.1].define(version: 2023_11_19_152112) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "invitations", force: :cascade do |t|
    t.bigint "sender_id", null: false
    t.bigint "recipient_id", null: false
    t.bigint "organization_id", null: false
    t.bigint "role_id", null: false
    t.string "token", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_invitations_on_organization_id"
    t.index ["recipient_id"], name: "index_invitations_on_recipient_id"
    t.index ["role_id"], name: "index_invitations_on_role_id"
    t.index ["sender_id"], name: "index_invitations_on_sender_id"
    t.index ["token"], name: "index_invitations_on_token", unique: true
  end

  create_table "memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.bigint "role_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id", "user_id"], name: "index_memberships_on_organization_id_and_user_id"
    t.index ["organization_id"], name: "index_memberships_on_organization_id"
    t.index ["role_id", "user_id"], name: "index_memberships_on_role_id_and_user_id"
    t.index ["role_id"], name: "index_memberships_on_role_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "metrics", force: :cascade do |t|
    t.time "start_time", null: false
    t.time "end_time", null: false
    t.date "date", null: false
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.virtual "duration", type: :interval, as: "(end_time - start_time)", stored: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date"], name: "index_metrics_on_date"
    t.index ["organization_id"], name: "index_metrics_on_organization_id"
    t.index ["user_id", "organization_id", "date"], name: "idx_user_organization_date_uniq", unique: true
    t.index ["user_id"], name: "index_metrics_on_user_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_organizations_on_name", unique: true
  end

  create_table "roles", force: :cascade do |t|
    t.string "name"
    t.jsonb "privileges", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_roles_on_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 100
    t.string "password_digest"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "invitations", "organizations"
  add_foreign_key "invitations", "roles"
  add_foreign_key "invitations", "users", column: "recipient_id"
  add_foreign_key "invitations", "users", column: "sender_id"
  add_foreign_key "memberships", "organizations"
  add_foreign_key "memberships", "roles"
  add_foreign_key "memberships", "users"
  add_foreign_key "metrics", "organizations"
  add_foreign_key "metrics", "users"
end
