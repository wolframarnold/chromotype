class CreateAssetUrns < ActiveRecord::Migration
  def change
    create_table :asset_urns do |t|
      t.string :urn, :limit => 256, :required => true
    end
    add_index :asset_urns, [:urn], :name => 'urn_udx', :unique => true
  end
end
