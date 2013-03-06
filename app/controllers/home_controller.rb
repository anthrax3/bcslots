class HomeController < ApplicationController
  include SuperSimpleAuth
  def generate_new_cookie_id args
    u = User.an_inactive_user
    u.active = true
    u.save!
    u.public_id
  end
  def render_show args
    @data = {}
    @data[:address] = args[:cookie_state]
    balance = BalanceChange.newest_for_user_with_public_id(args[:cookie_id].to_s).pluck('balance').try(:first)
    if not balance.nil?
      @data[:balance_in_dBTC] = (balance * 10).to_i.to_s;
      @data[:balance_in_cBTC] = (balance * 100).to_i.to_s;
      @data[:balance_in_mBTC] = (balance * 1000).to_i.to_s;
    else
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


