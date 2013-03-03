class ConditionalReelCombination < ActiveRecord::Base
  has_many :reel_combinations

  def self.find_by_reels reels 
    self
    .joins('join reel_combinations rc on rc.conditional_reel_combination_id = conditional_reel_combinations.id')
    .joins('join reels first  on first.id  = rc.first_id') .where('first.reel'  => reels[0].to_s)
    .joins('join reels second on second.id = rc.second_id').where('second.reel' => reels[1].to_s)
    .joins('join reels third  on third.id  = rc.third_id') .where('third.reel'  => reels[2].to_s)
  end
end
