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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130314062339) do

  create_table "gardens", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "zip_code"
    t.string   "phone"
  end

  create_table "gardens_users", :id => false, :force => true do |t|
    t.integer "garden_id"
    t.integer "user_id"
  end

  create_table "logs", :force => true do |t|
    t.float    "sunlight"
    t.float    "moisture"
    t.float    "temperature"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "plant_id"
  end

  create_table "plant_types", :force => true do |t|
    t.string   "name"
    t.integer  "sunlight"
    t.integer  "water"
    t.integer  "temperature"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "plants", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "garden_id"
    t.integer  "plant_type_id"
    t.date     "plant_date"
    t.string   "sensor_id"
    t.string   "health"
  end

  add_index "plants", ["sensor_id"], :name => "index_plants_on_sensor_id", :unique => true

  create_table "sensors", :id => false, :force => true do |t|
    t.string "sens_id", :null => false
  end

  add_index "sensors", ["sens_id"], :name => "index_sensors_on_sens_id", :unique => true

  create_table "tasks", :force => true do |t|
    t.string   "description"
    t.text     "schedule"
    t.integer  "plant_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "tasks", ["plant_id"], :name => "index_tasks_on_plant_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username"
    t.string   "phone"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
