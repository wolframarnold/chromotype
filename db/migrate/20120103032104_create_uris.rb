class CreateUris < ActiveRecord::Migration
  def change
    create_table :uris do |t|
      t.references :asset, :required => true
      t.string :sha, :limit => 64, :required => true
      t.string :uri, :limit => 2000, :required => true
      t.datetime :created_at
    end
    # MySQL can only have 760 chars in an index:
    add_index :urls, [:uri], :name => 'uri_idx', :length => 150
    add_index :urls, [:sha], :name => 'uri_sha_udx', :unique => true
  end
end
