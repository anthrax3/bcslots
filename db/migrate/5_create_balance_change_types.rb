class CreateBalanceChangeTypes < ActiveRecord::Migration
  def change
    create_table :balance_change_types do |t|
      t.string :change_type

      t.timestamps
    end
  end
end
