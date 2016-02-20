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

ActiveRecord::Schema.define(version: 20160220101242) do

  create_table "claims", force: :cascade do |t|
    t.integer  "repo_id",    limit: 4
    t.integer  "user_id",    limit: 4
    t.boolean  "approved",             default: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "claims", ["repo_id"], name: "index_claims_on_repo_id", using: :btree
  add_index "claims", ["user_id"], name: "index_claims_on_user_id", using: :btree

  create_table "repos", force: :cascade do |t|
    t.string   "url",          limit: 255
    t.integer  "user_id",      limit: 4
    t.boolean  "gifted",                     default: false
    t.integer  "gifted_to_id", limit: 4
    t.string   "new_url",      limit: 255
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.string   "title",        limit: 255
    t.text     "description",  limit: 65535
    t.string   "languages",    limit: 255
    t.string   "status",       limit: 255,   default: "gifted"
  end

  add_index "repos", ["gifted_to_id"], name: "index_repos_on_gifted_to_id", using: :btree
  add_index "repos", ["user_id"], name: "index_repos_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.string   "provider",               limit: 255
    t.string   "uid",                    limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
    t.string   "username",               limit: 255
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  add_foreign_key "claims", "repos"
  add_foreign_key "claims", "users"
  add_foreign_key "repos", "users"
end
