class CreateReels < ActiveRecord::Migration
  def change
    create_table :reels do |t|
      t.string :reel
      t.timestamps
    end
    add_index :reels, :reel, :unique => true
  end
end
