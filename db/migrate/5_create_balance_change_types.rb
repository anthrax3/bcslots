class CreateBalanceChangeTypes < ActiveRecord::Migration
  def change
    create_table :balance_change_types do |t|
      t.string :balance_change_type, :null => false

      t.timestamps
    end
    add_index :balance_change_types, :balance_change_type, :unique => true
  end
end
