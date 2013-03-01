class CreateReels < ActiveRecord::Migration
  def change
    create_table :reels do |t|
      t.string :reel, :null => false
      t.timestamps
    end
    add_index :reels, :reel, :unique => true
  end
end
