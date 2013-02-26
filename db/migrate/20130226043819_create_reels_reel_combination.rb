class CreateReelsReelCombination < ActiveRecord::Migration
  def change
    create_table :reels_reel_combinations do |t|
      t.integer :first_id 
      t.integer :second_id 
      t.integer :third_id 
      t.integer :reel_combination_id
      t.timestamps
    end
    add_foreign_key(:reels_reel_combinations, :reels, column: 'first_id')
    add_foreign_key(:reels_reel_combinations, :reels, column: 'second_id')
    add_foreign_key(:reels_reel_combinations, :reels, column: 'third_id')
    add_foreign_key(:reels_reel_combinations, :reel_combinations)
  end
end
