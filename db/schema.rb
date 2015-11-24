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

ActiveRecord::Schema.define(version: 20140913170603) do

  create_table "persons", :id => false, :force => true do |t|
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
    t.jsonb    "extras"
    t.text     "locked_fields"
    t.string   "id",                :limit => 47
    t.string   "name",              :limit => 300
    t.string   "sort_name",         :limit => 100
    t.string   "family_name",       :limit => 100
    t.string   "given_name",        :limit => 100
    t.string   "image",             :limit => 2000
    t.string   "gender",            :limit => 100
    t.string   "summary",           :limit => 500
    t.string   "national_identity", :limit => 300
    t.text     "biography"
    t.string   "birth_date",        :limit => 10
    t.string   "death_date",        :limit => 10
  end


end
