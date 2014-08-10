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

ActiveRecord::Schema.define(version: 20140809235946) do

  create_table "filters", force: true do |t|
    t.integer "project_id"
    t.string  "group"
    t.string  "var"
    t.integer "filter_val"
    t.string  "label"
    t.boolean "filter"
    t.boolean "banner"
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

  add_index "projects", ["project_id"], name: "index_projects_on_project_id"

  create_table "responses", force: true do |t|
    t.integer  "project_id"
    t.string   "respondent_id"
    t.string   "var"
    t.float    "response"
    t.float    "weight"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
