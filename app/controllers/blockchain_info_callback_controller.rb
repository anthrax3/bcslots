class BlockchainInfoCallbackController < ApplicationController
  include BlockchainInfoRestClient::AutomaticallySucessfulTestingCallback
  def receiving_address
    'hi'
  end
  def show
    handle_blockchain_info_callback {1 + 1}
  end
end
