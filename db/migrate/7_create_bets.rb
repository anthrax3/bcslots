class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.integer :current_weight, :null => false
      t.integer :current_payout, :null => false
      t.references :balance_change, :null => false
      t.references :reel_combination, :null => false

      t.timestamps
    end
    add_index :bets, :balance_change_id
    add_foreign_key :bets, :balance_changes, :dependent => :delete
    add_foreign_key :bets, :reel_combinations
  end
end
