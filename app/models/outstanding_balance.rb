class OutstandingBalance < ActiveRecord::Base
  belongs_to :user
  attr_accessible :change, :current
end
