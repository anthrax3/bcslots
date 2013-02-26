class CreateOutstandingBalances < ActiveRecord::Migration
  def change
    create_table :outstanding_balances do |t|
      t.decimal :current, :precision => 16, :scale => 8
      t.decimal :change,  :precision => 16, :scale => 8
      t.references :user

      t.timestamps
    end
    add_index :outstanding_balances, :user_id
    add_foreign_key :outstanding_balances, :users
  end
end
