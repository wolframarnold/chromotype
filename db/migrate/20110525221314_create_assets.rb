class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :type, :null => false
      t.references :directory
      t.string :basename
      t.timestamp :taken_at
      t.boolean :favorite
      t.boolean :hidden
      t.boolean :active
      t.string :thumbprint
      t.string :caption
      t.datetime :mtime
      t.timestamps
    end

    add_index :assets, [:thumbprint], :name => 'assets_thumbprint_udx', :unique => true

  end
end
