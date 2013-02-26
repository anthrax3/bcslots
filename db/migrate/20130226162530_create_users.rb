class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :public_id
      t.string :address

      t.timestamps
    end
  end
end
