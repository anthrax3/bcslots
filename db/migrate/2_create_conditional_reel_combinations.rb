class CreateConditionalReelCombinations < ActiveRecord::Migration
  def change
    create_table :conditional_reel_combinations do |t|
      t.string  :condition, :null => false
      t.integer :payout, :null => false
      t.integer :weight, :null => false

      t.timestamps
    end
    add_index :conditional_reel_combinations, :condition, :unique => true
  end
end
