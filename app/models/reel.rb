class Reel < ActiveRecord::Base
  after_commit do
    ReelCombination.clear_cache
  end
end
