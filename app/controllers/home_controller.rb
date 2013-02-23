class HomeController < ApplicationController
  @@cases = SafeCase.define
  .condition(:index_with_no_cookie_set) do |args|
    args[:method] == :index and
    args[:cookie_id].nil?
  end
  .condition(:index_with_cookie_set_and_valid_address) do |args|
    args[:method] == :index and
    not args[:cookie_id].nil? and
    not args[:cookie_address].nil?
  end
  .condition(:index_with_cookie_set_and_invalid_address) do |args|
    args[:method] == :index and
    not args[:cookie_id].nil? and
    args[:cookie_address].nil?
  end
  .condition(:show_with_cookie_set_and_valid_address_and_matching_url_id) do |args|
    args[:method] == :show and
    not args[:cookie_id].nil? and
    not args[:cookie_address].nil? and
    args[:url_address] == args[:cookie_address]
  end
  .condition(:show_with_cookie_set_and_valid_address_and_not_matching_invalid_url_id) do |args|
    args[:method] == :show and
    not args[:cookie_id].nil? and
    not args[:cookie_address].nil? and
    args[:url_address] != args[:cookie_address] and
    args[:url_id].nil?
  end
  .condition(:show_with_cookie_set_and_valid_address_and_not_matching_valid_url_id) do |args|
    args[:method] == :show and
    not args[:cookie_id].nil? and
    not args[:cookie_address].nil? and
    args[:url_address] != args[:cookie_address] and
    not args[:url_id].nil?
  end
  .condition(:show_with_cookie_set_and_invalid_address_and_not_matching_invalid_url_id) do |args|
    args[:method] == :show and
    not args[:cookie_id].nil? and
    args[:cookie_address].nil? and
    args[:url_address] != args[:cookie_address] and
    args[:url_id].nil?
  end
  .condition(:show_with_cookie_set_and_invalid_address_and_not_matching_valid_url_id) do |args|
    args[:method] == :show and
    not args[:cookie_id].nil? and
    args[:cookie_address].nil? and
    args[:url_address] != args[:cookie_address] and
    not args[:url_id].nil?
  end
  .condition(:show_with_no_cookie_set_and_valid_url_id) do |args|
    args[:method] == :show and
    args[:cookie_id].nil? and
    not args[:url_id].nil?
  end
  .last(:show_with_no_cookie_set_and_invalid_url_id) do |args|
    args[:method] == :show and
    args[:cookie_id].nil? and
    not args[:url_id].nil?
  end

  @@outcomes = @@cases
  .index_with_no_cookie_set do |args|
    args[:generate_and_redirect].call
  end
  .index_with_cookie_set_and_valid_address do |args|
    args[:redirect].call
  end
  .index_with_cookie_set_and_invalid_address do |args|
    args[:generate_and_redirect].call
  end
  .show_with_cookie_set_and_valid_address_and_matching_url_id do |args|
    args[:render].call
  end
  .show_with_cookie_set_and_valid_address_and_not_matching_invalid_url_id do |args|
    args[:render].call
  end
  .show_with_cookie_set_and_valid_address_and_not_matching_valid_url_id do |args|
    args[:render].call
  end
  .show_with_cookie_set_and_invalid_address_and_not_matching_invalid_url_id do |args|
    args[:generate_and_redirect].call
  end
  .show_with_cookie_set_and_invalid_address_and_not_matching_valid_url_id do |args|
    args[:set_cookie_and_render].call
  end
  .show_with_no_cookie_set_and_valid_url_id do |args|
    args[:set_cookie_and_render].call
  end
  .show_with_no_cookie_set_and_invalid_url_id do |args|
    args[:generate_and_redirect].call
  end

  def index
    r = Redis.new 

    args = {}
    args[:method] = :index
    args[:cookie_id] = cookies[:uuid]
    if not cookies[:uuid].nil?
      args[:cookie_address] = r.get cookies[:uuid]
    end

    args[:generate_and_redirect] = lambda do
      uuid_address = r.lpop Rails.application.config.redis.uuid_address_list_name 
      hash = JSON.parse(uuid_address)
      r.set hash['uuid'], hash['address']
      cookies[:uuid] = {:value => hash['uuid'], :expires => 10.years.from_now}
      redirect_to "/#{cookies[:uuid]}"
    end

    args[:redirect] = lambda do
      redirect_to :action => "show", :id => cookies[:uuid]
    end

    @@outcomes.call args
  end

  def show
    r = Redis.new 

    args = {}
    args[:method] = :show
    args[:cookie_id] = cookies[:uuid]
    args[:url_id] = params[:id]
    args[:url_address] = r.get args[:url_id]
    if not cookies[:uuid].nil?
      args[:cookie_address] = r.get cookies[:uuid]
    end



    args[:generate_and_redirect] = lambda do
      uuid_address = r.lpop Rails.application.config.redis.uuid_address_list_name 
      hash = JSON.parse(uuid_address)
      r.set hash["uuid"], hash["address"]
      cookies[:uuid] = {:value => hash["uuid"], :expires => 10.years.from_now}
      redirect_to :action => "show", :id => cookies[:uuid]
    end

    args[:render] = lambda do
      @address = args[:cookie_address]
    end

    args[:set_cookie_and_render] = lambda do
      cookies[:uuid] = {:value => args[:url_id], :expires => 10.years.from_now}
      @address = args[:cookie_address]
    end

    @@outcomes.call args
  end

  def state_machine state,url_id, address
    r = Redis.new
    case state
    when :visits_index_with_cookie_set_and_valid_address
      redirect_to :action => "show", :id => cookies[:uuid]
    when :visits_index_with_cookie_set_and_nil_address 
      uuid_address = r.lpop Rails.application.config.redis.uuid_address_list_name 
      hash = JSON.parse(uuid_address)
      r.set hash[:uuid], hash[:address]
      cookies[:uuid] = {:value => hash[:uuid], :expires => 10.years.from_now}
      redirect_to :action => "show", :id => cookies[:uuid]
    when :visits_index_with_no_cookie_set
      uuid_address = r.lpop Rails.application.config.redis.uuid_address_list_name 
      hash = JSON.parse(uuid_address)
      r.set hash[:uuid], hash[:address]
      cookies[:uuid] = {:value => hash[:uuid], :expires => 10.years.from_now}
      redirect_to :action => "show", :id => cookies[:uuid]
    when :visits_show_with_cookie_set_and_valid_address_and_matching_url_id
      @address = address
    when :visits_show_with_cookie_set_and_valid_address_and_not_matching_invalid_url_id
      #either ignore it or redirect, I'll choose to ignore it
      @address = address
    when :visits_show_with_cookie_set_and_valid_address_and_not_matching_valid_url_id
      #either switch cookie to new uuid, or ignore valid url. I'll choose to ignore it,
      # as it's slightly safer from a security standpoint (very slightly), and is better ux?
      @address = address
    when :visits_show_with_cookie_set_and_invalid_address_and_matching_url_id
      #bad cookie
      uuid_address = r.lpop Rails.application.config.redis.uuid_address_list_name 
      hash = JSON.parse(uuid_address)
      r.set hash[:uuid], hash[:address]
      cookies[:uuid] = {:value => hash[:uuid], :expires => 10.years.from_now}
      redirect_to :action => "show", :id => cookies[:uuid]
    when :visits_show_with_cookie_set_and_invalid_address_and_not_matching_invalid_url_id
      #bad cookie
      uuid_address = r.lpop Rails.application.config.redis.uuid_address_list_name 
      hash = JSON.parse(uuid_address)
      r.set hash[:uuid], hash[:address]
      cookies[:uuid] = {:value => hash[:uuid], :expires => 10.years.from_now}
      redirect_to :action => "show", :id => cookies[:uuid]
    when :visits_show_with_cookie_set_and_invalid_address_and_not_matching_valid_url_id
      cookies[:uuid] = {:value => url_id, :expires => 10.years.from_now}
      @address = r.get url_id
    when :visits_show_with_no_cookie_set_and_valid_url_id
      cookies[:uuid] = {:value => url_id, :expires => 10.years.from_now}
      @address = r.get url_id
    when state == :visits_show_with_no_cookie_set_and_invalid_url_id
      uuid_address = r.lpop Rails.application.config.redis.uuid_address_list_name 
      hash = JSON.parse(uuid_address)
      r.set hash[:uuid], hash[:address]
      cookies[:uuid] = {:value => hash[:uuid], :expires => 10.years.from_now}
      redirect_to :action => "show", :id => cookies[:uuid]
    end
  end



  #state machine:
  # case 1: user visits index with cookie set and a valid address
  # case 2: user visits index with cookie set and a nil address
  # case 3: user visits index with no cookie set 
  # case 4: user visits show with cookie set and a valid address and matching url id
  # case 5: user visits show with cookie set and a valid address and not matching invalid url id
  # case 5: user visits show with cookie set and a valid address and not matching valid url id
  # case 4: user visits show with cookie set and a invalid address and matching url id
  # case 4: user visits show with cookie set and a invalid address and not matching invalid url id
  # case 4: user visits show with cookie set and a invalid address and not matching valid url id
  # case 6: user visits show with no cookie set and a valid url id
  # case 6: user visits show with no cookie set and an invalid url id
  #
  #
  # results:
  # case1: redirect to show so valid will be in url
  # case2: create a new cookie and rediect so new address will show up
  # case3: create a new cookie and rediect so address will show up
  # case4: do nothing special
  # case5: redirect to show with valid address
  # case6: set cookie and show
  # case7: create valid address and cookie, and redirect

end


