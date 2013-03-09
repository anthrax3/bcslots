class Reel < ActiveRecord::Base
  after_commit do
    Rails.cache.delete ReelCombination.reel_combinations_cache_key
  end
end
