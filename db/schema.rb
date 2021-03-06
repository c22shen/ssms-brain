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

ActiveRecord::Schema.define(version: 20150326194308) do

  create_table "articles", force: true do |t|
    t.string   "title"
    t.text     "text"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "library_id"
    t.integer  "rating"
  end

  create_table "comments", force: true do |t|
    t.string   "commenter"
    t.text     "body"
    t.integer  "article_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id"

  create_table "libraries", force: true do |t|
    t.string   "name"
    t.float    "lat"
    t.float    "lon"
    t.string   "floors"
    t.string   "school"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "kind"
    t.boolean  "plug"
    t.boolean  "table"
    t.integer  "noise"
    t.float    "latitude"
    t.float    "longitude"
    t.string   "address"
    t.boolean  "wifi"
    t.boolean  "coffee"
    t.integer  "size"
  end

  create_table "messages", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.text     "message"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "seats", force: true do |t|
    t.integer  "uid"
    t.string   "status"
    t.float    "x"
    t.float    "y"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mode"
    t.float    "z"
    t.integer  "library_id"
    t.integer  "volume"
  end

  create_table "statuses", force: true do |t|
    t.string   "uid"
    t.string   "status"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "volume"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "mode"
    t.string   "option"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
