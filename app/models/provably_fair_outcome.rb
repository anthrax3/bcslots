class ProvablyFairOutcome < ActiveRecord::Base
  belongs_to :user
  def self.add_provably_fair_outcome_for_user_id user_id, collection_size
    p = ProvablyFairOutcome.new
    p.user_id = user_id
    p.position =  SecureRandom.random_number collection_size
    p.secret = SecureRandom.base64(22)
    p.save!
    p
  end
  def to_hash_for_user 
    concated = "#{self.position} #{self.secret}"
    hash = Digest::SHA512.new << concated
    hash.to_s[0..9]
  end
end
