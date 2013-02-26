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

ActiveRecord::Schema.define(:version => 20130226043819) do

  create_table "reel_combinations", :force => true do |t|
    t.string   "name"
    t.integer  "weight"
    t.integer  "payout"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reels", :force => true do |t|
    t.string   "reel"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "reels_reel_combinations", :force => true do |t|
    t.integer  "first_id"
    t.integer  "second_id"
    t.integer  "third_id"
    t.integer  "reel_combination_id"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_foreign_key "reels_reel_combinations", "reel_combinations", :name => "reels_reel_combinations_reel_combination_id_fk"
  add_foreign_key "reels_reel_combinations", "reels", :name => "reels_reel_combinations_first_id_fk", :column => "first_id"
  add_foreign_key "reels_reel_combinations", "reels", :name => "reels_reel_combinations_second_id_fk", :column => "second_id"
  add_foreign_key "reels_reel_combinations", "reels", :name => "reels_reel_combinations_third_id_fk", :column => "third_id"

end
