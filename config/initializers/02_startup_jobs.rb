class NewAddressJob
  extend HumanId
  extend BlockchainInfoRestClient::RubyOnRails::GenerateReceivingAddress

  @queue = Rails.application.config.jobs.queue_name 
  @retry_limit = -1

  def self.perform 
    buffer_size = Rails.application.config.jobs.new_addresses.buffer_size
    current_size = User.where(:active => false).limit(buffer_size).count

    while (current_size < buffer_size) do
      Rails.logger.debug "NewAddressJob: #{current_size} available addresses."
      
      response = generate_receiving_address
      puts "#{current_size} #{buffer_size}"
      Rails.logger.debug "NewAddressJob: generate receiving address complete."

      if (response[:code] != 200)
        raise response.to_s
      end

      u = User.new
      u.public_id = generate_human_id
      u.address = response[:data][:input_address]
      u.active = false
      u.save!

      current_size = User.where(:active => false).limit(buffer_size).count
    end
#    Resque.enqueue NewAddressJob
  end
end

#Resque.enqueue NewAddressJob
