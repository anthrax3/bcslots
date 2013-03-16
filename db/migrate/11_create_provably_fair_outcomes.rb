class CreateProvablyFairOutcomes < ActiveRecord::Migration
  def change
    create_table :provably_fair_outcomes do |t|
      t.references :user, :null => false
      t.references :reel_combination, :null => false
      t.string :salt
      t.timestamps
    end
    add_index :provably_fair_outcomes, :user_id, :unique => true
    add_foreign_key :provably_fair_outcomes, :users, :dependent => :delete
    add_foreign_key :provably_fair_outcomes, :reel_combinations
  end
end
