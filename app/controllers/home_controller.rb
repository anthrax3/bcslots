class HomeController < ApplicationController
  def index
    #four cases:
    # 1) has no uuid or address
    # 2) has a uuid, but no address
    # 3) has a uuid and address
    # 4) has no uuid, but an address
    # ignore 4 for now
    # case 2 happens in between job queue enter and completion
    # if refresh, should make a new job and ignore last address, spamming server more? I say yes
    # , to be a little simpler
    r = Redis.new
    c = cookies[:uuid]
    if (c.nil? || r.get(c).nil?)
      uuid = SecureRandom.uuid
      cookies[:uuid] = {
        :value => uuid,
        :expires => 10.years.from_now
      }
      Resque.enqueue(NewAddressJob, uuid)
    end
  end
end

class NewAddressJob
  @queue = :new_address

  @retry_limit = -1

  def self.perform uuid
    puts uuid
    r = Redis.new
    if r.get(uuid).nil?
      c = Curl.get("https://blockchain.info/api/receive?method=create&address=13wpvosrDc25KDbBGmj3sFA5EaoGzVi8hw&anonymous=false&callback=")
      if (c.response_code != 200)
        raise [c.response_code, uuid].to_s
      end
      response_data = JSON.parse(c.body_str)
      address = response_data["input_address"]
      puts address
      r.set uuid, address
    end
  end
end
