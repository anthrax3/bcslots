class ConditionalReelCombination < ActiveRecord::Base
  has_many :reel_combinations
  after_commit do
    ReelCombination.clear_cache
  end
end
