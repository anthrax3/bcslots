class NewAddressJob
  extend HumanId
  @queue = Rails.application.config.jobs.new_addresses.queue_name 
  @retry_limit = -1

  def self.perform 
    buffer_size = Rails.application.config.jobs.new_addresses.buffer_size
    r = Redis.new
    uuid_address_list = Rails.application.config.redis.uuid_address_list_name
    current_size = r.llen uuid_address_list
    Rails.logger.debug "NewAddressJob: #{uuid_address_list} current_size: #{current_size}."
    while (current_size < buffer_size) do
      c = Curl.get("https://blockchain.info/api/receive?method=create&address=13wpvosrDc25KDbBGmj3sFA5EaoGzVi8hw&anonymous=false&callback=")
      Rails.logger.debug "NewAddressJob: curl complete."
      if (c.response_code != 200)
        raise [c.response_code, uuid].to_s
      end
      response_data = JSON.parse(c.body_str)
      address = response_data["input_address"]
      uuid = generate_human_id
      Rails.logger.info "NewAddressJob: pushing uuid: #{uuid}, address: #{address} to #{uuid_address_list}."
      r.lpush uuid_address_list, {:uuid => uuid, :address => address}.to_json
      current_size = r.llen uuid_address_list
      Rails.logger.debug "NewAddressJob: #{uuid_address_list} current_size: #{current_size}."
    end
    Resque.enqueue NewAddressJob
  end
end

Resque.enqueue NewAddressJob
