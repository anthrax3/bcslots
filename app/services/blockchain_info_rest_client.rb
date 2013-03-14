module BlockchainInfoRestClient
  module Rails
    module Settings
      def blockchain_info_secret_token
        r = Object::Rails.configuration.blockchain_info_rest_client.secret_token
        raise 'define Object::Rails.configuration.blockchain_info_rest_client.secret_token' if r.nil?
        r
      end
      def blockchain_info_address
        r = Object::Rails.configuration.blockchain_info_rest_client.address
        raise 'define Object::Rails.configuration.blockchain_info_rest_client.address' if r.nil?
        r
      end
      def blockchain_info_anonymous
        r = Object::Rails.configuration.blockchain_info_rest_client.anonymous
        raise 'define Object::Rails.configuration.blockchain_info_rest_client.anonymous' if r.nil?
        r
      end
      def blockchain_info_callback_address
        r = Object::Rails.configuration.blockchain_info_rest_client.callback_address
        raise 'define Object::Rails.configuration.blockchain_info_rest_client.callback_address' if r.nil?
        r
      end
    end
    module GenerateReceivingAddress
      include Settings
      def _generate_receiving_address
        BlockchainInfoRestClient::Implementation::GenerateReceivingAddress.new
      end
      def _set_up_generate_receiving_address_args
        args = {}

        args[:receiving_address]= blockchain_info_address
        args[:anonymous] = blockchain_info_anonymous
        args[:callback_address] = blockchain_info_callback_address
        args[:secret_token] = blockchain_info_secret_token
        args
      end
      def generate_receiving_address
        b = _generate_receiving_address
        args = _set_up_generate_receiving_address_args
        b.call args
      end
    end
    module Callback
      include Settings
      def _handle_blockchain_info_callback_implementation
        b = BlockchainInfoRestClient::Implementation::BlockchainInfoCallback.new
        if (Object::Rails.env == 'development')
          class << b
            def blockchain_info_ip_address
              '127.0.0.1'
            end
          end
        end
        b
      end
      def _set_up_callback_args
        args = {}
        args[:destination_address] = blockchain_info_address
        args[:secret_token] = blockchain_info_secret_token
        args[:test] = params[:test]
        args[:requester_ip_address] = request.remote_ip
        args[:incoming_secret_token] = params[:secret_token]
        args[:incoming_destination_address] = params[:destination_address]
        args[:input_address] = params[:input_address]
        args[:transaction_hash] = params[:transaction_hash]
        args[:input_transaction_hash] = params[:input_transaction_hash]
        args[:value] = params[:value]
        args[:confirmations] = params[:confirmations]
        args
      end
      def handle_blockchain_info_callback
        c = _handle_blockchain_info_callback_implementation
        args = _set_up_callback_args
        result = c.call args
        lambda do |&success|
        lambda do |&failure|
        if result.nil?
          failure.call
        else
          success.call args
          render :text => c.response_for_succesful_requester
        end
        end
        end
      end
    end
  end
  module Implementation
    class GenerateReceivingAddress
      def blockchain_info_address
        'https://blockchain.info'
      end
      def callback_address_uri_encoded callback_address, secret_token
        ERB::Util.url_encode "#{callback_address}?secret_token=#{secret_token}"
      end
      def receiving_address_url_string blockchain_info_address, receiving_address, anonymous, callback_address, secret_token
        "#{blockchain_info_address}/api/receive?method=create&address=#{receiving_address}&anonymous=#{anonymous.to_s}&callback=#{callback_address_uri_encoded callback_address, secret_token}"
      end
      def post_to_receiving_address_endpoint address
        c = Curl.post address
        {:code => c.response_code, :data => c.body_str}
      end
      def parse_receiving_address_data response_data
        JSON.parse response_data, :symbolize_names => true
      end
      def call args
        receiving_address = args[:receiving_address]
        anonymous = args[:anonymous]
        callback_address = args[:callback_address]
        secret_token = args[:secret_token]

        address = receiving_address_url_string blockchain_info_address, receiving_address, anonymous, callback_address, secret_token
        response = post_to_receiving_address_endpoint address
        {:data => parse_receiving_address_data(response[:data]), :code => response[:code]}
      end
    end
    class BlockchainInfoCallback
      def blockchain_info_ip_address
        '91.223.16.20'
      end
      def response_for_succesful_requester
        '*ok*'
      end
      def call args
        secret_token = args[:secret_token]
        address = args[:destination_address]
        test = args[:test]

        requester_ip_address = args[:requester_ip_address]
        incoming_secret_token = args[:incoming_secret_token]
        destination_address = args[:incoming_destination_address]
        test = args[:test]

        if (blockchain_info_ip_address == requester_ip_address) and
          (incoming_secret_token == secret_token) and
          (address == destination_address) and
          (test == 'false')
          response_for_succesful_requester
        else
          nil
        end
      end
    end
  end
end
