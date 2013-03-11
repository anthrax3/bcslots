class Bet < ActiveRecord::Base
  belongs_to :balance_change, :dependent => :delete_all
  belongs_to :reel_combination
end
