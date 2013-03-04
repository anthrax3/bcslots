class CreateAllowedBets < ActiveRecord::Migration
  def change
    create_table :allowed_bets do |t|
      t.decimal :allowed_bet, :precision => 16, :scale => 8
      t.timestamps
    end
  end
end
