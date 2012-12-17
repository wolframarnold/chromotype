class CreateAssetsTags < ActiveRecord::Migration
  def change
    create_table :asset_tags, :id => false do |t|
      t.references :asset, :required => true
      t.references :tag, :required => true
    end
    add_index :asset_tags, [:tag_id, :asset_id]
  end
end
