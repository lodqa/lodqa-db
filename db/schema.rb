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

ActiveRecord::Schema[6.1].define(version: 2018_12_05_045544) do

  create_table "connection_index_requests", force: :cascade do |t|
    t.string "target_name", limit: 40, null: false
    t.string "state", limit: 8, null: false
    t.string "latest_error", limit: 255, default: "", null: false
    t.integer "estimated_seconds_to_complete", limit: 8
    t.integer "number_of_triples", limit: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "connections", force: :cascade do |t|
    t.string "target_name", limit: 40, null: false
    t.string "subject", limit: 255, null: false
    t.string "object", limit: 255, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["target_name", "subject", "object"], name: "index_connections_on_target_name_and_subject_and_object", unique: true
  end

  create_table "klasses", force: :cascade do |t|
    t.string "target_name", limit: 40, null: false
    t.string "url", limit: 255, null: false
    t.index ["target_name", "url"], name: "index_klasses_on_target_name_and_url", unique: true
  end

  create_table "labels", force: :cascade do |t|
    t.string "target_name", limit: 40, null: false
    t.string "url", limit: 255, null: false
    t.string "label", limit: 255, null: false
    t.index ["target_name", "url", "label"], name: "index_labels_on_target_name_and_url_and_label", unique: true
  end

  create_table "lexical_index_requests", force: :cascade do |t|
    t.string "target_name", limit: 40, null: false
    t.string "state", limit: 8, null: false
    t.string "latest_error", limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.bigint "estimated_seconds_to_complete"
    t.bigint "number_of_triples"
    t.index ["target_name"], name: "index_jobs_on_target_name_and_job_name", unique: true
  end

  create_table "predicates", force: :cascade do |t|
    t.string "target_name", limit: 40, null: false
    t.string "url", limit: 255, null: false
    t.index ["target_name", "url"], name: "index_predicates_on_target_name_and_url", unique: true
  end

  create_table "targets", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "user_id"
    t.string "parser_url"
    t.string "endpoint_url"
    t.string "graph_uri"
    t.string "dictionary_url"
    t.integer "max_hop"
    t.text "ignore_predicates"
    t.text "sortal_predicates"
    t.text "sample_queries"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "home"
    t.boolean "publicity"
    t.string "pred_dictionary_url"
    t.index ["user_id"], name: "index_targets_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "root", default: false
    t.string "username"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["username"], name: "index_users_on_username", unique: true
  end

end
