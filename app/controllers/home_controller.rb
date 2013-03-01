class HomeController < ApplicationController
  include SuperSimpleAuth
  def generate_new_cookie_id args
    u = User.an_inactive_user
    u.active = true
    u.save!
    u.public_id
  end
  def render_show args
    @address = args[:cookie_state]
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


