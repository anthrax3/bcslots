class NewUserJob
  include BlockchainInfoRestClient::Rails::GenerateReceivingAddress
  include HumanId
  def perform
    buffer_size = Rails.application.config.jobs.new_addresses.buffer_size
    current_size = User.where(:active => false).limit(buffer_size).count
    while (current_size < buffer_size) do
      Rails.logger.info "NewUserJob: #{current_size} available users."

      response = generate_receiving_address

      if (response[:code] != 200)
        raise response.to_s
      end

      Rails.logger.debug "NewUserJob: generate receiving address complete."

      u = User.new
      u.public_id = generate_human_id
      u.address = response[:data][:input_address]
      u.active = false
      u.save!


      current_size = User.where(:active => false).limit(buffer_size).count
    end
  end

  def reschedule_at time, attempts
    Time.now
  end
end
