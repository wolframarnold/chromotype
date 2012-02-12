class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.string :type
      t.references :directory
      t.string :basename
      t.timestamp :taken_at
      t.boolean :favorite
      t.boolean :hidden
      t.string :thumbprint
      t.string :caption
      t.datetime :mtime
      t.timestamps
      t.datetime :deleted_at
    end

    add_index :assets, [:thumbprint], :name => 'assets_thumbprint_udx', :unique => true

  end
end
