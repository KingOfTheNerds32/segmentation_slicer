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

ActiveRecord::Schema.define(version: 20170115220814) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "cool", id: false, force: true do |t|
    t.integer "vendorid"
    t.text    "employee"
    t.integer "count"
  end

  create_table "filters", force: true do |t|
    t.integer "project_id"
    t.string  "group"
    t.string  "var"
    t.integer "filter_val"
    t.string  "label"
    t.boolean "filter"
    t.boolean "banner"
  end

  create_table "id_1", id: false, force: true do |t|
    t.string "respondent_id"
  end

  create_table "metrics", force: true do |t|
    t.integer  "project_id"
    t.string   "bucket"
    t.string   "var"
    t.string   "label"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "projects", force: true do |t|
    t.integer  "project_id"
    t.string   "project_name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "projects", ["project_id"], name: "index_projects_on_project_id", using: :btree

  create_table "pvt", id: false, force: true do |t|
    t.integer "vendorid"
    t.integer "emp1"
    t.integer "emp2"
    t.integer "emp3"
    t.integer "emp4"
    t.integer "emp5"
  end

# Could not dump table "respondents" because of following StandardError
#   Unknown type 'jsonb' for column 'respondent'

  create_table "responses", force: true do |t|
    t.integer  "project_id"
    t.string   "respondent_id"
    t.string   "var"
    t.float    "response"
    t.float    "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "responses", ["project_id"], name: "index_responses_on_project_id", using: :btree
  add_index "responses", ["respondent_id"], name: "index_responses_on_respondent_id", using: :btree
  add_index "responses", ["response"], name: "index_responses_on_response", using: :btree
  add_index "responses", ["var"], name: "index_responses_on_var", using: :btree

  create_table "tblunpivotexample", id: false, force: true do |t|
    t.integer "itemno"
    t.integer "totalamt"
    t.integer "item1"
    t.integer "item2"
    t.integer "item3"
    t.integer "item4"
  end

  create_table "test", id: false, force: true do |t|
    t.string "array", array: true
  end

end
