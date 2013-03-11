class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.string :transaction_hash, :null => false
      t.string :input_transaction_hash, :null => false
      t.integer :confirmations, :null => false
      t.references :balance_change, :null => false
      t.timestamps
    end
    add_index :deposits, :balance_change_id
    add_foreign_key :deposits, :balance_changes, :dependent => :delete
  end
end
