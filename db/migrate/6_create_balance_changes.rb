class CreateBalanceChanges < ActiveRecord::Migration
  def change
    create_table :balance_changes do |t|
      t.decimal :balance, :precision => 16, :scale => 8
      t.decimal :change,  :precision => 16, :scale => 8
      t.references :balance_change_type
      t.references :user

      t.timestamps
    end
    add_index :balance_changes, :user_id
    add_foreign_key :balance_changes, :users
    add_foreign_key :balance_changes, :balance_change_types
  end
end
