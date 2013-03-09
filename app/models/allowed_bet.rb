class AllowedBet < ActiveRecord::Base
  after_commit do
    Rails.cache.write balance_change_types_cache_key, self
  end
  def self.allowed_bets_cache_key
    'allowed_bets'
  end
  def self.allowed_bets
    Rails.cache.fetch(allowed_bets_cache_key) do
      AllowedBets.pluck(:allowed_bet)
    end
  end
end
