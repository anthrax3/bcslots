class HomeController < ApplicationController
  include SuperSimpleAuth
  def generate_new_cookie_id args
    r = Redis.new 
    uuid_address = r.lpop Rails.application.config.redis.uuid_address_list_name 
    hash = JSON.parse(uuid_address)
    r.set hash['uuid'], hash['address']
    hash['uuid']
  end
  def render_show args
    @address = args[:cookie_state]
  end
  def get_cookie_state args
    Redis.new.get args[:cookie_id]
  end
  def get_param_state args
    Redis.new.get args[:param_id]
  end
  def index
    super_simple_auth_index
  end

  def show
    super_simple_auth_show
  end
end


