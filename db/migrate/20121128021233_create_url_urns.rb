class CreateUrlUrns < ActiveRecord::Migration
  def change
    create_table :asset_url_urn do |t|
      t.references :asset_url, :required => true
      t.references :urn, :required => true
    end
    add_index :asset_url_urn, [:urn_id, :asset_url_id], :name => 'asset_url_urn_udx', :unique => true
  end
end
