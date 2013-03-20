class CreateProvablyFairOutcomes < ActiveRecord::Migration
  def change
    create_table :provably_fair_outcomes do |t|
      t.references :user, :null => false
      t.integer :position, :null => false
      t.string :secret
      t.timestamps
    end
    add_index :provably_fair_outcomes, :user_id, :unique => true
    add_foreign_key :provably_fair_outcomes, :users, :dependent => :delete
  end
end
