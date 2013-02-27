class CreateReelCombinations < ActiveRecord::Migration
  def change
    create_table :reel_combinations do |t|
      t.integer :first_id 
      t.integer :second_id 
      t.integer :third_id 
      t.references :conditional_reel_attribute
      t.timestamps
    end
    add_foreign_key(:reel_combinations, :reels, column: 'first_id')
    add_foreign_key(:reel_combinations, :reels, column: 'second_id')
    add_foreign_key(:reel_combinations, :reels, column: 'third_id')
    add_foreign_key(:reel_combinations, :conditional_reel_attributes)
    add_index :reel_combinations, [:first_id, :second_id, :third_id], :unique => true
  end
end
