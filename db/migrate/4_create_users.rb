class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :public_id, :null => false
      t.string :address, :null => false
      t.boolean :active, :null => false

      t.timestamps
    end
    add_index :users, :public_id, :unique => true
    add_index :users, [:active, :public_id], :unique => true
  end
end
