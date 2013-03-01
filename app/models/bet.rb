class Bet < ActiveRecord::Base
  belongs_to :outstanding_balance
  belongs_to :reel_combination
  attr_accessible :change, :current
end
