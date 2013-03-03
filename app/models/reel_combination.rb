class ReelCombination < ActiveRecord::Base
  belongs_to :first,  :class_name =>  'Reel', :foreign_key => 'first_id'
  belongs_to :second, :class_name =>  'Reel', :foreign_key => 'second_id'
  belongs_to :third,  :class_name =>  'Reel', :foreign_key => 'third_id'
  belongs_to :conditional_reel_combination

  def self.find_by_reels reels 
    self
    .joins('join reels first  on first.id  = reel_combinations.first_id') .where('first.reel'  => reels[0].to_s)
    .joins('join reels second on second.id = reel_combinations.second_id').where('second.reel' => reels[1].to_s)
    .joins('join reels third  on third.id  = reel_combinations.third_id') .where('third.reel'  => reels[2].to_s)
  end
end
