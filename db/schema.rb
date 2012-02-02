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

ActiveRecord::Schema.define(:version => 20120103032104) do

  create_table "asset_uris", :force => true do |t|
    t.integer  "asset_id"
    t.string   "sha",        :limit => 64
    t.string   "uri",        :limit => 2000
    t.datetime "created_at"
  end

  add_index "asset_uris", ["sha"], :name => "uri_sha_udx", :unique => true
  add_index "asset_uris", ["uri"], :name => "uri_idx"

  create_table "assets", :force => true do |t|
    t.string   "type",         :null => false
    t.integer  "directory_id"
    t.string   "basename"
    t.datetime "taken_at"
    t.boolean  "favorite"
    t.boolean  "hidden"
    t.boolean  "active"
    t.string   "thumbprint"
    t.string   "caption"
    t.datetime "mtime"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "assets", ["thumbprint"], :name => "assets_thumbprint_udx", :unique => true

  create_table "assets_tags", :id => false, :force => true do |t|
    t.integer "asset_id", :null => false
    t.integer "tag_id",   :null => false
  end

  add_index "assets_tags", ["tag_id", "asset_id"], :name => "index_assets_tags_on_tag_id_and_asset_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "settings", :force => true do |t|
    t.string   "var",                       :null => false
    t.text     "value"
    t.integer  "target_id"
    t.string   "target_type", :limit => 30
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "settings", ["target_type", "target_id", "var"], :name => "index_settings_on_target_type_and_target_id_and_var", :unique => true

  create_table "tag_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id",   :null => false
    t.integer "descendant_id", :null => false
    t.integer "generations",   :null => false
  end

  add_index "tag_hierarchies", ["ancestor_id", "descendant_id"], :name => "index_tag_hierarchies_on_ancestor_id_and_descendant_id", :unique => true
  add_index "tag_hierarchies", ["descendant_id"], :name => "index_tag_hierarchies_on_descendant_id"

  create_table "tags", :force => true do |t|
    t.string   "type",        :null => false
    t.integer  "parent_id"
    t.string   "name",        :null => false
    t.string   "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "tags", ["name", "parent_id"], :name => "index_tags_on_name_and_parent_id", :unique => true
  add_index "tags", ["type", "name", "parent_id"], :name => "index_tags_on_type_and_name_and_parent_id", :unique => true

end
