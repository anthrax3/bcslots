class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.integer :current_weight
      t.integer :current_payout
      t.references :balance_change
      t.references :reel_combination

      t.timestamps
    end
    add_index :bets, :balance_change_id
    add_foreign_key :bets, :balance_changes
    add_foreign_key :bets, :reel_combinations
  end
end
