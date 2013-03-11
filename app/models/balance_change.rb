class BalanceChange < ActiveRecord::Base
  belongs_to :user, :dependent => :delete
  belongs_to :balance_change_type
  has_one :bet
  has_one :deposit
  belongs_to :next,  :class_name =>  'BalanceChange', :foreign_key => 'next_id'
  def self.newest_for_user_with_public_id public_id
    self
    .joins(:user)
    .where('users.public_id' => public_id)
    .where(:next_id => nil)
  end
end
