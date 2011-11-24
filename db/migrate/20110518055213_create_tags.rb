class CreateTags < ActiveRecord::Migration
  def change
    create_table :tags do |t|
      t.integer :parent_id
      t.string :name, :null => false
      t.string :display_name
      t.string :description
    end

    add_index :tags, [:name, :parent_id], :unique => true

    create_table :tag_hierarchies, :id => false do |t|
      t.integer :ancestor_id, :null => false
      t.integer :descendant_id, :null => false
      t.integer :generations, :null => false
    end

    # For "all progeny of..." selects:
    add_index :tag_hierarchies, [:ancestor_id, :descendant_id], :unique => true

    # For "all ancestors of..." selects
    add_index :tag_hierarchies, [:descendant_id]
  end
end
