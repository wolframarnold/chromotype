class CreateAssetUrns < ActiveRecord::Migration
  def change
    create_table :asset_urns do |t|
      t.references :asset_url, :required => true
      t.string :urn, :limit => 256, :required => true
    end
    add_index :asset_urns, [:asset_url_id, :urn], :name => 'asset_url_urn_udx', :unique => true
    add_index :asset_urns, [:urn], :name => 'asset_urn_udx', :unique => true
  end
end
