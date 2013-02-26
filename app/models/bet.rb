class Bet < ActiveRecord::Base
  belongs_to :outstanding_balance
  attr_accessible :change, :current
end
