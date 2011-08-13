class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :type
      t.references :directory
      t.string :url
      t.string :basename
      t.timestamp :taken_at
      t.boolean :favorite
      t.boolean :hidden
      t.boolean :active
      t.string :checksum
      t.timestamps
    end
  end
end
