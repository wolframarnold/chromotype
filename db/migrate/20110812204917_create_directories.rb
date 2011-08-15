class CreateDirectories < ActiveRecord::Migration
  def change
    create_table :directories do |t|
      t.integer :parent_id
      t.string :path
      t.timestamp :processed_at
      t.timestamp :last_mtime
      t.timestamps
    end

    create_table :directories_hierarchies, :id => false do |t|
      t.integer :ancestor_id, :null => false
      t.integer :descendant_id, :null => false
      t.integer :generations, :null => false
    end
  end
end
