class Bet < ActiveRecord::Base
  belongs_to :balance_change
  belongs_to :reel_combination
end
