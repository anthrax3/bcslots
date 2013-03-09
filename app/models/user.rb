class User < ActiveRecord::Base
  has_many :balance_changes

  def self.an_inactive_user
    User.where(:active => false).limit(1).first!
  end
end
