class CreateAssetsTags < ActiveRecord::Migration
  def change
    create_table :asset_tags, :id => false do |t|
      t.references :asset, :null => false
      t.references :tag, :null => false
    end
    add_index :asset_tags, [:tag_id, :asset_id]
  end
end
