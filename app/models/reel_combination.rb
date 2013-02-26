class ReelCombination < ActiveRecord::Base
  has_many :reel_reel_combinations
  # attr_accessible :title, :body
end
