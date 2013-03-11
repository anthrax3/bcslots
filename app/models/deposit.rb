class Deposit < ActiveRecord::Base
  belongs_to :balance_change, :dependent => :delete
end
