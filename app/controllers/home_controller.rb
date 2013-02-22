class HomeController < ApplicationController
  def index

    r = Redis.new
    c = cookies[:uuid]

    if (c.nil?)
      uuid_address = r.lpop Rails.application.config.redis.uuid_address_list_name 
      if (uuid_address).nil?
        #TODO: make this more graceful
        raise 'out of uuids!'
      end
      hash = JSON.parse(uuid_address)
      r.set hash[:uuid], hash[:address]
      cookies[:uuid] = {
        :value => hash[:uuid],
        :expires => 10.years.from_now
      }
      @address = hash[:address]
    else

      uuid_address = r.get c
      if (uuid_address.nil?)
        #TODO: this could happen from fsync per sec
      end
      hash = JSON.parse(uuid_address)
      @address = hash[:address]
    end

  end



  #state machine:
  # case 1: user visits index with cookie set and a valid address
  # case 2: user visits index with cookie set and a nil address
  # case 3: user visits index with no cookie set 
  # case 4: user visits show with cookie set and a valid address
  # case 5: user visits show with cookie set and a nil address
  # case 6: user visits show with no cookie set and a valid address
  # case 7: user visits show with no cookie set and a nil address
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
  def show
    r = Redis.new
    c = cookies[:uuid]

    if (not params[:id].nil?)
      existing_address = r.get params[:id]
    end
    if (c.nil? && (not existing_address.nil?))
      cookies[:uuid] = {
        :value => params[:id],
        :expires => 10.years.from_now
      }
      @address = existing_address
    elsif (c.nil?)
      uuid_address = r.lpop Rails.application.config.redis.uuid_address_list_name 
      if (uuid_address).nil?
        #TODO: make this more graceful
        raise 'out of uuids!'
      end
      hash = JSON.parse(uuid_address)
      r.set hash[:uuid], hash[:address]
      cookies[:uuid] = {
        :value => hash[:uuid],
        :expires => 10.years.from_now
      }
      @address = hash[:address]
    else
      uuid_address = r.get c
      if (uuid_address.nil?)
        #TODO: this could happen from fsync per sec
      end
      hash = JSON.parse(uuid_address)
      @address = hash[:address]
    end
  end

end


