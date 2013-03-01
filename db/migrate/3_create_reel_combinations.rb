class CreateReelCombinations < ActiveRecord::Migration
  def change
    create_table :reel_combinations do |t|
      t.integer :first_id, :null => false
      t.integer :second_id, :null => false
      t.integer :third_id, :null => false
      t.references :conditional_reel_combination, :null => false
      t.timestamps
    end
    add_foreign_key(:reel_combinations, :reels, column: 'first_id')
    add_foreign_key(:reel_combinations, :reels, column: 'second_id')
    add_foreign_key(:reel_combinations, :reels, column: 'third_id')
    add_foreign_key(:reel_combinations, :conditional_reel_combinations)
    add_index :reel_combinations, [:first_id, :second_id, :third_id], :unique => true
  end
end
