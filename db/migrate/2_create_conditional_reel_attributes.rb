class CreateConditionalReelAttributes < ActiveRecord::Migration
  def change
    create_table :conditional_reel_attributes do |t|
      t.string  :condition
      t.integer :payout
      t.integer :weight

      t.timestamps
    end
    add_index :conditional_reel_attributes, :condition, :unique => true
  end
end
