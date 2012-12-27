class CreateAssetUrns < ActiveRecord::Migration
  def change
    create_table :asset_urns do |t|
      t.references :asset_url, :required => true
      t.string :asset_urn, :limit => 256, :required => true
    end
    add_index :asset_urns, [:asset_url_id, :asset_urn], :name => 'asset_url_urn_udx', :unique => true
    add_index :asset_urns, [:asset_urn], :name => 'asset_urn_udx', :unique => true
  end
end
