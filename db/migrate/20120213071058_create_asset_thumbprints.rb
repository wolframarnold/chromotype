class CreateAssetThumbprints < ActiveRecord::Migration
  def change
    create_table :asset_thumbprints do |t|
      t.integer :asset_id
      t.string :type, :limit => 20
      t.string :thumbprint, :limit => 512
      t.timestamps
    end
    add_index :asset_thumbprints, [:asset_id]
    add_index :asset_thumbprints, [:thumbprint]
  end
end
