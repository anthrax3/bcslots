class CreateReels < ActiveRecord::Migration
  def change
    create_table :reels do |t|
      t.string :reel
      t.timestamps
    end
  end
end
