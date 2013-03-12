class User < ActiveRecord::Base
  has_many :balance_changes
  after_save :enqueue_new_user_job
  after_destroy :enqueue_new_user_job


  def enqueue_new_user_job
    Delayed::Job.enqueue NewUserJob.new
    true
  end

  def max_attempts
    999_999_999
  end

  def self.an_inactive_user
    User.where(:active => false).limit(1).first!
  end
end
