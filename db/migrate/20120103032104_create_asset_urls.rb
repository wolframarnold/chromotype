class CreateAssetUrls < ActiveRecord::Migration
  def change
    create_table :asset_urls do |t|
      t.references :asset, :required => true
      t.string :url, :limit => 2000, :required => true
      # this is the sha of the URL itself, not the content at that URL:
      t.string :url_sha, :limit => 40, :required => true
      # this is the sha of the content at the URI
      t.string :content_sha, :limit => 40, :required => true
      # the value at that URI the last time we imported
      t.integer :file_size
      # the value at that URI the last time we imported
      t.datetime :last_modified
      # The updated_at will be updated by content_sha
      t.timestamps
    end
    # MySQL can only have 760 chars in an index, so let's index the url by sha.
    add_index :asset_urls, [:url_sha], :name => 'asset_url_sha_udx', :unique => true
    add_index :asset_urls, [:last_modified, :file_size], :name => 'url_mtime_size_idx'
    add_index :asset_urls, [:content_sha], :name => 'url_content_idx'
  end
end
