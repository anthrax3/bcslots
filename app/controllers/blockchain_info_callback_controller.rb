class BlockchainInfoCallbackController < ApplicationController
  include BlockchainInfoRestClient::Rails::Callback
  def show
    puts 'entering callback'
    puts params
    handle_blockchain_info_callback.call{|args|
      puts 'callback successful'
      ActiveRecord::Base.transaction do
        u = User.where(:address => args[:input_address]).first!
        bc = BalanceChange
        .newest_for_user_with_public_id(u.public_id.to_s)
        .select('balance_changes.*')
        .first

        change =  (BigDecimal(args[:value]) / 100000000)
        next_bc = BalanceChange.new
        next_bc.user = u
        if bc.nil?
          next_bc.balance = change
        else
          next_bc.balance = bc.balance + change
        end
        next_bc.change = change
        next_bc.balance_change_type = BalanceChangeType.where(:balance_change_type => 'deposit').first!

        deposit = Deposit.new
        deposit.transaction_hash = args[:transaction_hash]
        deposit.input_transaction_hash = args[:input_transaction_hash]
        deposit.confirmations = args[:confirmations]

        next_bc.deposit = deposit

        next_bc.save!
        if (not bc.nil?)
          bc.next = next_bc
          bc.save!
        end
      end
    }.call{ render :text => 'no'}
  end
end
