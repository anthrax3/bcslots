class HomeController < ApplicationController
  include SuperSimpleAuth
  def generate_new_cookie_id args
    ActiveRecord::Base.transaction do
    u = User.an_inactive_user
    u.active = true
    u.save!

    ProvablyFairOutcome.add_provably_fair_outcome_for_user_id u.id, ReelCombination.weighted_reel_combinations.size
    u.public_id
    end
  end
  def render_show args
    @data = {}
    @data[:id] = args[:cookie_id]
    @data[:address] = args[:cookie_state]
    balance_change = BalanceChange.newest_for_user_with_public_id(args[:cookie_id].to_s).try(:first)
    if not balance_change.nil?
      balance = balance_change.balance
      @data[:next_hash] = ProvablyFairOutcome.where(:user_id => balance_change.user_id).first!.to_hash_for_user
      @data[:balance_in_dBTC] = (balance * 10).to_i.to_s;
      @data[:balance_in_cBTC] = (balance * 100).to_i.to_s;
      @data[:balance_in_mBTC] = (balance * 1000).to_i.to_s;
    else
      @data[:next_hash] = ProvablyFairOutcome.joins(:user).where(:users => {:public_id => @data[:id]}).first!.to_hash_for_user
      @data[:balance_in_dBTC] = 0.to_s;
      @data[:balance_in_cBTC] = 0.to_s;
      @data[:balance_in_mBTC] = 0.to_s;
    end
  end
  def get_cookie_state args
    User.where(:public_id => args[:cookie_id]).first.try(:address)
  end
  def get_param_state args
    User.where(:public_id => args[:param_id]).first.try(:address)
  end
  def index
    super_simple_auth_index
  end

  def show
    super_simple_auth_show
  end
end


