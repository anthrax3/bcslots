class ConditionalReelCombination < ActiveRecord::Base
  has_many :reel_combinations
  after_commit do
    ReelCombination.clear_cache
    ProvablyFairOutcome.delete_all
  end
  after_save :clear_provably_fair_outcomes
  after_destroy :clear_provably_fair_outcomes

  def clear_provably_fair_outcomes
    ProvablyFairOutcome.delete_all
  end
end
