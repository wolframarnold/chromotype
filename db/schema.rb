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

ActiveRecord::Schema.define(:version => 20110526005214) do

  create_table "assets", :force => true do |t|
    t.string   "url"
    t.string   "checksum"
    t.string   "type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "assets_tags", :id => false, :force => true do |t|
    t.integer "asset_id"
    t.integer "tag_id"
  end

  add_index "assets_tags", ["tag_id", "asset_id"], :name => "index_assets_tags_on_tag_id_and_asset_id"

  create_table "settings", :force => true do |t|
    t.string   "var",                       :null => false
    t.text     "value"
    t.integer  "target_id"
    t.string   "target_type", :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["target_type", "target_id", "var"], :name => "index_settings_on_target_type_and_target_id_and_var", :unique => true

  create_table "tags", :force => true do |t|
    t.integer "parent_id"
    t.string  "name",         :null => false
    t.string  "display_name"
    t.string  "description"
  end

  add_index "tags", ["name", "parent_id"], :name => "index_tags_on_name_and_parent_id", :unique => true

  create_table "tags_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id",   :null => false
    t.integer "descendant_id", :null => false
    t.integer "generations",   :null => false
  end

  add_index "tags_hierarchies", ["ancestor_id", "descendant_id"], :name => "index_tags_hierarchies_on_ancestor_id_and_descendant_id", :unique => true
  add_index "tags_hierarchies", ["descendant_id"], :name => "index_tags_hierarchies_on_descendant_id"

end
