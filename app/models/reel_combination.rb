class ReelCombination < ActiveRecord::Base
  belongs_to :first,  :class_name =>  'Reel', :foreign_key => 'first_id'
  belongs_to :second, :class_name =>  'Reel', :foreign_key => 'second_id'
  belongs_to :third,  :class_name =>  'Reel', :foreign_key => 'third_id'
  belongs_to :conditional_reel_combination
end
