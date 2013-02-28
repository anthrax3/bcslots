class BalanceChange < ActiveRecord::Base
  belongs_to :user
  belongs_to :balance_change_type
#  attr_accessible :change, :current
end
