class Deposit < ActiveRecord::Base
  belongs_to :balance_change, :dependent => :delete_all
end
