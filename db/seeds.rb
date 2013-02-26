# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

reels = ['cherries', 'orange', 'plum', 'bell', 'bar', 'seven']

reel_combinations = [
  {'name' => 'cherries_cherries_cherries', 'weight' => 16, 'payout' => 10},
  {'name' => 'cherries_cherries_bar',      'weight' => 16, 'payout' => 10},
  {'name' => 'cherries_cherries_any',      'weight' => 32, 'payout' => 5},
  {'name' => 'cherries_any_any',           'weight' => 64, 'payout' => 2},
  {'name' => 'orange_orange_orange',       'weight' => 15, 'payout' => 12},
  {'name' => 'orange_orange_bar',          'weight' => 15, 'payout' => 12},
  {'name' => 'plum_plum_plum',             'weight' => 8,  'payout' => 20},
  {'name' => 'plum_plum_bar',              'weight' => 8,  'payout' => 20},
  {'name' => 'bell_bell_bell',             'weight' => 4,  'payout' => 50},
  {'name' => 'bell_bell_bar',              'weight' => 4,  'payout' => 50},
  {'name' => 'bar_bar_bar',                'weight' => 2,  'payout' => 100},
  {'name' => 'seven_seven_seven',          'weight' => 1,  'payout' => 250},
  {'name' => 'any_other',                  'weight' => 39, 'payout' => -1}
]

def idempotent collection, field_name, ar_class
  collection.each do |c|
    not_exists = ar_class.where(field_name => c).first.nil?
    if not_exists
      ar = ar_class.new
      ar.send"#{field_name}=",  c
      ar.save!
    end
  end
end



idempotent reels, :reel, Reel


reel_combinations.each do |rc|
  not_exists = ReelCombination.where(:name => rc['name']).first.nil?
  if not_exists
    ar = ReelCombination.new
    ar.name   = rc['name']
    ar.weight = rc['weight']
    ar.payout = rc['payout']
    ar.save!
  end
end


reels.each do |first|
  reels.each do |second|
    reels.each do |third|
      ar = ReelsReelCombination.new
      ar.first = Reel.where(:reel => first).first!
      ar.second = Reel.where(:reel => second).first!
      ar.third = Reel.where(:reel => third).first!
      r = [first.to_sym, second.to_sym, third.to_sym]
      if r == [:cherries, :cherries, :cherries]
        ar.reel_combination = ReelCombination.where(:name => 'cherries_cherries_cherries').first!
      elsif reels == [:cherries, :cherries, :bar]
        ar.reel_combination = ReelCombination.where(:name => 'cherries_cherries_bar').first!
      elsif r[0..1] == [:cherries, :cherries]
        ar.reel_combination = ReelCombination.where(:name => 'cherries_cherries_any').first!
      elsif r[0] == :cherries
        ar.reel_combination = ReelCombination.where(:name => 'cherries_any_any').first!
      elsif r == [:orange, :orange, :orange]
        ar.reel_combination = ReelCombination.where(:name => 'orange_orange_orange').first!
      elsif r == [:orange, :orange, :bar]
        ar.reel_combination = ReelCombination.where(:name => 'orange_orange_bar').first!
      elsif r == [:plum, :plum, :plum]
        ar.reel_combination = ReelCombination.where(:name => 'plum_plum_plum').first!
      elsif r == [:plum, :plum, :bar]
        ar.reel_combination = ReelCombination.where(:name => 'plum_plum_bar').first!
      elsif r == [:bell, :bell, :bell]
        ar.reel_combination = ReelCombination.where(:name => 'bell_bell_bell').first!
      elsif r == [:bell, :bell, :bar]
        ar.reel_combination = ReelCombination.where(:name => 'bell_bell_bar').first!
      elsif r == [:bar, :bar, :bar]
        ar.reel_combination = ReelCombination.where(:name => 'bar_bar_bar').first!
      elsif r == [:seven, :seven, :seven]
        ar.reel_combination = ReelCombination.where(:name => 'seven_seven_seven').first!
      else
        ar.reel_combination = ReelCombination.where(:name => 'any_other').first!
      end
      ar.save!
    end
  end
end
