# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 7) do

  create_table "balance_change_types", :force => true do |t|
    t.string   "change_type"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "balance_changes", :force => true do |t|
    t.decimal  "balance",                :precision => 16, :scale => 8
    t.decimal  "change",                 :precision => 16, :scale => 8
    t.integer  "balance_change_type_id"
    t.integer  "user_id"
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "balance_changes", ["user_id"], :name => "index_balance_changes_on_user_id"

  create_table "bets", :force => true do |t|
    t.integer  "credits"
    t.decimal  "multiplier",          :precision => 16, :scale => 8
    t.integer  "weight"
    t.integer  "payout"
    t.integer  "balance_change_id"
    t.integer  "reel_combination_id"
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  create_table "conditional_reel_combinations", :force => true do |t|
    t.string   "condition"
    t.integer  "payout"
    t.integer  "weight"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "conditional_reel_combinations", ["condition"], :name => "index_conditional_reel_combinations_on_condition", :unique => true

  create_table "reel_combinations", :force => true do |t|
    t.integer  "first_id"
    t.integer  "second_id"
    t.integer  "third_id"
    t.integer  "conditional_reel_combination_id"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "reel_combinations", ["first_id", "second_id", "third_id"], :name => "index_reel_combinations_on_first_id_and_second_id_and_third_id", :unique => true

  create_table "reels", :force => true do |t|
    t.string   "reel"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "reels", ["reel"], :name => "index_reels_on_reel", :unique => true

  create_table "users", :force => true do |t|
    t.string   "public_id"
    t.string   "address"
    t.boolean  "active"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["public_id"], :name => "index_users_on_public_id", :unique => true

  add_foreign_key "balance_changes", "balance_change_types", :name => "balance_changes_balance_change_type_id_fk"
  add_foreign_key "balance_changes", "users", :name => "balance_changes_user_id_fk"

  add_foreign_key "bets", "balance_changes", :name => "bets_balance_change_id_fk"
  add_foreign_key "bets", "reel_combinations", :name => "bets_reel_combination_id_fk"

  add_foreign_key "reel_combinations", "conditional_reel_combinations", :name => "reel_combinations_conditional_reel_combination_id_fk"
  add_foreign_key "reel_combinations", "reels", :name => "reel_combinations_first_id_fk", :column => "first_id"
  add_foreign_key "reel_combinations", "reels", :name => "reel_combinations_second_id_fk", :column => "second_id"
  add_foreign_key "reel_combinations", "reels", :name => "reel_combinations_third_id_fk", :column => "third_id"

end
