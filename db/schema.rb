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

ActiveRecord::Schema.define(:version => 20121128021233) do

  create_table "asset_tags", :id => false, :force => true do |t|
    t.integer "asset_id"
    t.integer "tag_id"
  end

  add_index "asset_tags", ["tag_id", "asset_id"], :name => "index_asset_tags_on_tag_id_and_asset_id"

  create_table "asset_url_urn", :force => true do |t|
    t.integer "asset_url_id"
    t.integer "urn_id"
  end

  add_index "asset_url_urn", ["urn_id", "asset_url_id"], :name => "asset_url_urn_udx", :unique => true

  create_table "asset_urls", :force => true do |t|
    t.integer  "asset_id"
    t.string   "url",        :limit => 2000
    t.string   "url_sha",    :limit => 40
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "asset_urls", ["url_sha"], :name => "asset_url_sha_udx", :unique => true

  create_table "asset_urns", :force => true do |t|
    t.string "urn", :limit => 256
  end

  add_index "asset_urns", ["urn"], :name => "urn_udx", :unique => true

  create_table "assets", :force => true do |t|
    t.string   "type"
    t.boolean  "favorite"
    t.boolean  "hidden"
    t.string   "basename"
    t.string   "caption"
    t.string   "description"
    t.datetime "taken_at"
    t.datetime "lost_at"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "settings", :force => true do |t|
    t.string   "var"
    t.text     "value"
    t.integer  "target_id"
    t.string   "target_type", :limit => 30
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "settings", ["target_type", "target_id", "var"], :name => "index_settings_on_target_type_and_target_id_and_var", :unique => true

  create_table "tag_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id"
    t.integer "descendant_id"
    t.integer "generations"
  end

  add_index "tag_hierarchies", ["ancestor_id", "descendant_id"], :name => "index_tag_hierarchies_on_ancestor_id_and_descendant_id", :unique => true
  add_index "tag_hierarchies", ["descendant_id"], :name => "index_tag_hierarchies_on_descendant_id"

  create_table "tags", :force => true do |t|
    t.string   "type"
    t.integer  "parent_id"
    t.string   "name"
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "tags", ["name", "parent_id"], :name => "index_tags_on_name_and_parent_id", :unique => true
  add_index "tags", ["type", "name", "parent_id"], :name => "index_tags_on_type_and_name_and_parent_id", :unique => true

end
