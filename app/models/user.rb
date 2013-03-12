class User < ActiveRecord::Base
  has_many :balance_changes
  after_save :enqueue_new_user_job
  after_destroy :enqueue_new_user_job


  def enqueue_new_user_job
    buffer_size = Rails.application.config.jobs.new_user.buffer_size
    current_size = User.where(:active => false).limit(buffer_size).count
    if current_size < buffer_size
      Delayed::Job.enqueue NewUserJob.new
    end
    true
  end

  def max_attempts
    999_999_999
  end

  def self.an_inactive_user
    User.where(:active => false).limit(1).first!
  end
end
