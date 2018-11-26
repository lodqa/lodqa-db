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

ActiveRecord::Schema.define(version: 20181126083451) do

  create_table "jobs", force: :cascade do |t|
    t.string   "target_name",  limit: 40,               null: false
    t.string   "job_name",     limit: 30,               null: false
    t.string   "state",        limit: 8,                null: false
    t.string   "latest_error", limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jobs", ["target_name", "job_name"], name: "index_jobs_on_target_name_and_job_name", unique: true

  create_table "klasses", force: :cascade do |t|
    t.string "target_name", limit: 40,  null: false
    t.string "url",         limit: 255, null: false
  end

  add_index "klasses", ["target_name", "url"], name: "index_klasses_on_target_name_and_url", unique: true

  create_table "labels", force: :cascade do |t|
    t.string "target_name", limit: 40,  null: false
    t.string "url",         limit: 255, null: false
    t.string "label",       limit: 255, null: false
  end

  add_index "labels", ["target_name", "url", "label"], name: "index_labels_on_target_name_and_url_and_label", unique: true

  create_table "predicates", force: :cascade do |t|
    t.string "target_name", limit: 40,  null: false
    t.string "url",         limit: 255, null: false
  end

  add_index "predicates", ["target_name", "url"], name: "index_predicates_on_target_name_and_url", unique: true

  create_table "targets", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.string   "parser_url"
    t.string   "endpoint_url"
    t.string   "graph_uri"
    t.string   "dictionary_url"
    t.integer  "max_hop"
    t.text     "ignore_predicates"
    t.text     "sortal_predicates"
    t.text     "sample_queries"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "home"
    t.boolean  "publicity"
    t.string   "pred_dictionary_url"
  end

  add_index "targets", ["user_id"], name: "index_targets_on_user_id"

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "root",                   default: false
    t.string   "username"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  add_index "users", ["username"], name: "index_users_on_username", unique: true

end
