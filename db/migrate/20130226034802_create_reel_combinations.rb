class CreateReelCombinations < ActiveRecord::Migration
  def change
    create_table :reel_combinations do |t|
      t.string :name
      t.integer :weight
      t.integer :payout
      t.timestamps
    end
  end
end
