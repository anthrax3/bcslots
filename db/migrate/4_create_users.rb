class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :public_id
      t.string :address

      t.timestamps
    end
    add_index :users, :public_id, :unique => true
  end
end
