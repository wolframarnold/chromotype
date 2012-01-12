class CreateAssetsTags < ActiveRecord::Migration
  def change
    create_table :assets_tags, :id => false do |t|
      t.references :asset, :null => false
      t.references :tag, :null => false
    end
    add_index :assets_tags, [:tag_id, :asset_id]
  end
end
