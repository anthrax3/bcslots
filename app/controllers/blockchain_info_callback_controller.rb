class BlockchainInfoCallbackController < ApplicationController
  include BlockchainInfoRestClient::Rails::Callback
  def show
    handle_blockchain_info_callback do |args|
      ActiveRecord::Base.transaction do
        u = User.where(:address => args[:input_address]).first!
        bc = BalanceChange
        .newest_for_user_with_public_id(u.public_id.to_s)
        .first

        if bc.nil?
          next_bc = BalanceChange.new
          next_bc.user = user
          next_bc.balance = BigDecimal(args[:value]) / 100000000
          next_bc.change = next_bc.balance
          next_bc.balance_change_type = BalanceChangeType.where(:balance_change_type => 'deposit').first!

          deposit = Deposit.new
          deposit.transaction_hash = args[:transaction_hash]
          deposit.input_transaction_hash = args[:input_transaction_hash]
          deposit.confirmations = args[:confirmations]

          next_bc.deposit = deposit
        end


      end
    end
  end
end
