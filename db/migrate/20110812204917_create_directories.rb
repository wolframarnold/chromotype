class CreateDirectories < ActiveRecord::Migration
  def change
    create_table :directories do |t|
      t.references :parent
      t.timestamp :processed_at
      t.timestamp :last_mtime
      t.timestamps
    end
  end
end
