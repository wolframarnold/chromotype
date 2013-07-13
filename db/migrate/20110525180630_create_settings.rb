class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings, :force => true do |t|
      t.string :key, :required => true
      t.text :value, :required => true
      t.timestamps
    end

    add_index :settings, [:key], :unique => true
  end
end
