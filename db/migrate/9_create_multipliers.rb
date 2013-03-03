class CreateMultipliers < ActiveRecord::Migration
  def change
    create_table :multipliers do |t|
      t.decimal :multiplier, :precision => 16, :scale => 8
      t.timestamps
    end
  end
end
