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

ActiveRecord::Schema.define(:version => 20120628212451) do

  create_table "active_admin_comments", :force => true do |t|
    t.string   "resource_id",   :null => false
    t.string   "resource_type", :null => false
    t.integer  "author_id"
    t.string   "author_type"
    t.text     "body"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "namespace"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], :name => "index_active_admin_comments_on_author_type_and_author_id"
  add_index "active_admin_comments", ["namespace"], :name => "index_active_admin_comments_on_namespace"
  add_index "active_admin_comments", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "admin_users", :force => true do |t|
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
  end

  add_index "admin_users", ["email"], :name => "index_admin_users_on_email", :unique => true
  add_index "admin_users", ["reset_password_token"], :name => "index_admin_users_on_reset_password_token", :unique => true

  create_table "ecm_market_data_bars", :force => true do |t|
    t.datetime "start_at"
    t.integer  "volume"
    t.float    "open"
    t.float    "high"
    t.float    "low"
    t.float    "close"
    t.integer  "ecm_market_data_time_series_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  add_index "ecm_market_data_bars", ["ecm_market_data_time_series_id"], :name => "index_ecm_market_data_bars_on_ecm_market_data_time_series_id"

  create_table "ecm_market_data_imports", :force => true do |t|
    t.integer  "ecm_market_data_time_series_id"
    t.string   "data_file_name"
    t.integer  "data_file_size"
    t.string   "data_content_type"
    t.datetime "data_updated_at"
    t.string   "data_image_fingerprint"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "ecm_market_data_instruments", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "ecm_market_data_time_series_count"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "ecm_market_data_providers", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "ecm_market_data_time_series_count"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "ecm_market_data_resolutions", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "ecm_market_data_time_series_count"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  create_table "ecm_market_data_time_series", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "ecm_market_data_bars_count"
    t.integer  "ecm_market_data_provider_id"
    t.integer  "ecm_market_data_instrument_id"
    t.integer  "ecm_market_data_resoution_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

end
