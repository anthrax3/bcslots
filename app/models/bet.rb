class Bet < ActiveRecord::Base
  belongs_to :balance_change, :dependent => :destroy
  belongs_to :reel_combination
end
