class CreateUrns < ActiveRecord::Migration
  def change
    create_table :urns do |t|
      t.string :urn, :limit => 64, :required => true
    end
    add_index :urns, [:urn], :name => 'urn_udx', :unique => true
  end
end
