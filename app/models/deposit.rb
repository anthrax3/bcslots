class Deposit < ActiveRecord::Base
  belongs_to :balance_change, :dependent => :destroy
end
