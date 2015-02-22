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

ActiveRecord::Schema.define(version: 20150222151134) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "batches", force: true do |t|
    t.boolean  "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "e_modules", force: true do |t|
    t.integer  "batch_id"
    t.integer  "e_user_id"
    t.integer  "scolaryear"
    t.string   "id_user_history"
    t.string   "codemodule"
    t.string   "codeinstance"
    t.string   "title"
    t.integer  "id_instance"
    t.datetime "date_ins"
    t.string   "cycle"
    t.string   "grade"
    t.integer  "credits"
    t.string   "flags"
    t.string   "barrage"
    t.string   "instance_id"
    t.integer  "module_rating"
    t.integer  "semester"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "e_notes", force: true do |t|
    t.integer  "batch_id"
    t.integer  "e_user_id"
    t.integer  "e_module_id"
    t.integer  "scolaryear"
    t.string   "codemodule"
    t.string   "titlemodule"
    t.string   "codeinstance"
    t.string   "codeacti"
    t.string   "title"
    t.datetime "date"
    t.string   "correcteur"
    t.float    "final_note"
    t.text     "comment"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "e_users", force: true do |t|
    t.integer  "batch_id"
    t.string   "title"
    t.string   "login"
    t.string   "nom"
    t.string   "prenom"
    t.string   "picture"
    t.string   "location"
    t.string   "uid"
    t.string   "gid"
    t.string   "promo"
    t.integer  "credits"
    t.float    "gpa_bachelor"
    t.float    "gpa_master"
    t.float    "gpa_average"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "average"
    t.string   "year"
    t.string   "school"
    t.integer  "last_batch",   default: 0
  end

  create_table "schools", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
