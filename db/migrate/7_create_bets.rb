class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.integer :credits
      t.decimal :multiplier, :precision => 16, :scale => 8
      t.integer :weight
      t.integer :payout
      t.references :balance_change
      t.references :reel_combination

      t.timestamps
    end
    add_foreign_key :bets, :balance_changes
    add_foreign_key :bets, :reel_combinations
  end
end
