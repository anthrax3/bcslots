# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
#

reels = ['cherries', 'orange', 'plum', 'bell', 'bar', 'seven']

conditional_reel_combinations = [
  {'condition' => 'cherries cherries cherries', 'weight' => 16, 'payout' => 10},
  {'condition' => 'cherries cherries bar',      'weight' => 16, 'payout' => 10},
  {'condition' => 'cherries cherries any',      'weight' => 32, 'payout' => 5},
  {'condition' => 'cherries any any',           'weight' => 64, 'payout' => 2},
  {'condition' => 'orange orange orange',       'weight' => 15, 'payout' => 12},
  {'condition' => 'orange orange bar',          'weight' => 15, 'payout' => 12},
  {'condition' => 'plum plum plum',             'weight' => 8,  'payout' => 20},
  {'condition' => 'plum plum bar',              'weight' => 8,  'payout' => 20},
  {'condition' => 'bell bell bell',             'weight' => 4,  'payout' => 50},
  {'condition' => 'bell bell bar',              'weight' => 4,  'payout' => 50},
  {'condition' => 'bar bar bar',                'weight' => 2,  'payout' => 100},
  {'condition' => 'seven seven seven',          'weight' => 1,  'payout' => 250},
  {'condition' => 'any other',                  'weight' => 39, 'payout' => -1}
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
idempotent ['deposit', 'bet', 'withdrawal'], :change_type, BalanceChangeType


conditional_reel_combinations.each do |rc|
  not_exists = ConditionalReelCombination.where(:condition => rc['condition']).first.nil?
  if not_exists
    ar = ConditionalReelCombination.new
    ar.condition   = rc['condition']
    ar.weight = rc['weight']
    ar.payout = rc['payout']
    ar.save!
  end
end


reels.each do |first|
  reels.each do |second|
    reels.each do |third|
      ar = ReelCombination.new
      ar.first = Reel.where(:reel => first).first!
      ar.second = Reel.where(:reel => second).first!
      ar.third = Reel.where(:reel => third).first!
      r = [first.to_sym, second.to_sym, third.to_sym]
      if r == [:cherries, :cherries, :cherries]
        ar.conditional_reel_combination = ConditionalReelCombination.where(:condition => 'cherries cherries cherries').first!
      elsif reels == [:cherries, :cherries, :bar]
        ar.conditional_reel_combination = ConditionalReelCombination.where(:condition => 'cherries cherries bar').first!
      elsif r[0..1] == [:cherries, :cherries]
        ar.conditional_reel_combination = ConditionalReelCombination.where(:condition => 'cherries cherries any').first!
      elsif r[0] == :cherries
        ar.conditional_reel_combination = ConditionalReelCombination.where(:condition => 'cherries any any').first!
      elsif r == [:orange, :orange, :orange]
        ar.conditional_reel_combination = ConditionalReelCombination.where(:condition => 'orange orange orange').first!
      elsif r == [:orange, :orange, :bar]
        ar.conditional_reel_combination = ConditionalReelCombination.where(:condition => 'orange orange bar').first!
      elsif r == [:plum, :plum, :plum]
        ar.conditional_reel_combination = ConditionalReelCombination.where(:condition => 'plum plum plum').first!
      elsif r == [:plum, :plum, :bar]
        ar.conditional_reel_combination = ConditionalReelCombination.where(:condition => 'plum plum bar').first!
      elsif r == [:bell, :bell, :bell]
        ar.conditional_reel_combination = ConditionalReelCombination.where(:condition => 'bell bell bell').first!
      elsif r == [:bell, :bell, :bar]
        ar.conditional_reel_combination = ConditionalReelCombination.where(:condition => 'bell bell bar').first!
      elsif r == [:bar, :bar, :bar]
        ar.conditional_reel_combination = ConditionalReelCombination.where(:condition => 'bar bar bar').first!
      elsif r == [:seven, :seven, :seven]
        ar.conditional_reel_combination = ConditionalReelCombination.where(:condition => 'seven seven seven').first!
      else
        ar.conditional_reel_combination = ConditionalReelCombination.where(:condition => 'any other').first!
      end
      ar.save!
    end
  end
end


