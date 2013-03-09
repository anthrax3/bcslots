class BalanceChangeType < ActiveRecord::Base
  after_commit do
    Rails.cache.write balance_change_types_cache_key, self
  end

  def self.balance_change_types_cache_key
    'balance_change_types'
  end
  def self.balance_change_types
    Rails.cache.fetch(balance_change_types_cache_key) do
      BalanceChangeType.all
    end
  end
end
