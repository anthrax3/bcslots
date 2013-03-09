class ConditionalReelCombination < ActiveRecord::Base
  has_many :reel_combinations
  after_commit do
    Rails.cache.delete ReelCombination.reel_combinations_cache_key
  end
end
