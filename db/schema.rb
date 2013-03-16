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

ActiveRecord::Schema.define(:version => 11) do

  create_table "allowed_bets", :force => true do |t|
    t.decimal  "allowed_bet", :precision => 16, :scale => 8, :null => false
    t.datetime "created_at",                                 :null => false
    t.datetime "updated_at",                                 :null => false
  end

  create_table "balance_change_types", :force => true do |t|
    t.string   "balance_change_type", :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "balance_change_types", ["balance_change_type"], :name => "index_balance_change_types_on_balance_change_type", :unique => true

  create_table "balance_changes", :force => true do |t|
    t.decimal  "balance",                :precision => 16, :scale => 8, :null => false
    t.decimal  "change",                 :precision => 16, :scale => 8, :null => false
    t.integer  "balance_change_type_id",                                :null => false
    t.integer  "next_id"
    t.integer  "user_id",                                               :null => false
    t.datetime "created_at",                                            :null => false
    t.datetime "updated_at",                                            :null => false
  end

  add_index "balance_changes", ["user_id", "next_id"], :name => "index_balance_changes_on_user_id_and_next_id", :unique => true

  create_table "bets", :force => true do |t|
    t.integer  "current_weight",      :null => false
    t.integer  "current_payout",      :null => false
    t.integer  "balance_change_id",   :null => false
    t.integer  "reel_combination_id", :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "bets", ["balance_change_id"], :name => "index_bets_on_balance_change_id"

  create_table "conditional_reel_combinations", :force => true do |t|
    t.string   "condition",  :null => false
    t.integer  "payout",     :null => false
    t.integer  "weight",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "conditional_reel_combinations", ["condition"], :name => "index_conditional_reel_combinations_on_condition", :unique => true

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "deposits", :force => true do |t|
    t.string   "transaction_hash",       :null => false
    t.string   "input_transaction_hash", :null => false
    t.integer  "confirmations",          :null => false
    t.integer  "balance_change_id",      :null => false
    t.datetime "created_at",             :null => false
    t.datetime "updated_at",             :null => false
  end

  add_index "deposits", ["balance_change_id"], :name => "index_deposits_on_balance_change_id"

  create_table "provably_fair_outcomes", :force => true do |t|
    t.integer  "user_id",             :null => false
    t.integer  "reel_combination_id", :null => false
    t.string   "salt"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "provably_fair_outcomes", ["user_id"], :name => "index_provably_fair_outcomes_on_user_id", :unique => true

  create_table "reel_combinations", :force => true do |t|
    t.integer  "first_id",                        :null => false
    t.integer  "second_id",                       :null => false
    t.integer  "third_id",                        :null => false
    t.integer  "conditional_reel_combination_id", :null => false
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "reel_combinations", ["first_id", "second_id", "third_id"], :name => "index_reel_combinations_on_first_id_and_second_id_and_third_id", :unique => true

  create_table "reels", :force => true do |t|
    t.string   "reel",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "reels", ["reel"], :name => "index_reels_on_reel", :unique => true

  create_table "users", :force => true do |t|
    t.string   "public_id",  :null => false
    t.string   "address",    :null => false
    t.boolean  "active",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "users", ["active", "public_id"], :name => "index_users_on_active_and_public_id", :unique => true
  add_index "users", ["address"], :name => "index_users_on_address", :unique => true
  add_index "users", ["public_id"], :name => "index_users_on_public_id", :unique => true

  add_foreign_key "balance_changes", "balance_change_types", :name => "balance_changes_balance_change_type_id_fk"
  add_foreign_key "balance_changes", "balance_changes", :name => "balance_changes_next_id_fk", :column => "next_id"
  add_foreign_key "balance_changes", "users", :name => "balance_changes_user_id_fk", :dependent => :delete

  add_foreign_key "bets", "balance_changes", :name => "bets_balance_change_id_fk", :dependent => :delete
  add_foreign_key "bets", "reel_combinations", :name => "bets_reel_combination_id_fk"

  add_foreign_key "deposits", "balance_changes", :name => "deposits_balance_change_id_fk", :dependent => :delete

  add_foreign_key "provably_fair_outcomes", "reel_combinations", :name => "provably_fair_outcomes_reel_combination_id_fk"
  add_foreign_key "provably_fair_outcomes", "users", :name => "provably_fair_outcomes_user_id_fk", :dependent => :delete

  add_foreign_key "reel_combinations", "conditional_reel_combinations", :name => "reel_combinations_conditional_reel_combination_id_fk"
  add_foreign_key "reel_combinations", "reels", :name => "reel_combinations_first_id_fk", :column => "first_id"
  add_foreign_key "reel_combinations", "reels", :name => "reel_combinations_second_id_fk", :column => "second_id"
  add_foreign_key "reel_combinations", "reels", :name => "reel_combinations_third_id_fk", :column => "third_id"

end
