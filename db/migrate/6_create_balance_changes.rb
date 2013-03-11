class CreateBalanceChanges < ActiveRecord::Migration
  def change
    create_table :balance_changes do |t|
      t.decimal :balance, :precision => 16, :scale => 8, :null => false
      t.decimal :change,  :precision => 16, :scale => 8, :null => false
      t.references :balance_change_type, :null => false
      t.integer :next_id
      t.references :user, :null => false

      t.timestamps
    end
    add_index :balance_changes, [:user_id, :next_id], :unique => true
    add_foreign_key :balance_changes, :users, :dependent => :delete
    add_foreign_key :balance_changes, :balance_change_types
    add_foreign_key(:balance_changes, :balance_changes, column: 'next_id')
  end
end
