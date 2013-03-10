# Be sure to restart your server when you modify this file.

# Your secret key for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!
# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
class NewAddressJob
  include BlockchainInfoRestClient::Rails::GenerateReceivingAddress
  include HumanId
  def execute
    Thread.new do 
      loop do
        sleep 1
        new_address_job
      end
    end
  end
  def new_address_job
    begin
      ActiveRecord::Base.connection_pool.with_connection do
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
      end
    rescue Exception => e
      Rails.logger.error "NewAddressJob: #{e}"
      retry
    end
  end
end

NewAddressJob.new.execute
