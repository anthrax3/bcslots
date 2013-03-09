class CreateDeposits < ActiveRecord::Migration
  def change
    create_table :deposits do |t|
      t.string :transaction_hash, :null => false
      t.string :input_transaction_hash, :null => false
      t.integer :confirmations, :null => false
      t.timestamps
    end
  end
end
