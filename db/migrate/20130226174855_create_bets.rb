class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.integer, :credits
      t.decimal, :multiplier
      t.integer :first_id 
      t.integer :second_id 
      t.integer :third_id 
      t.references :outstanding_balance

      t.timestamps
    end
    add_index :bets, :user_id
    add_foreign_key :bets, :outstanding_balances
    add_foreign_key(:reels_reel_combinations, :reels, column: 'first_id')
    add_foreign_key(:reels_reel_combinations, :reels, column: 'second_id')
    add_foreign_key(:reels_reel_combinations, :reels, column: 'third_id')
  end
end
