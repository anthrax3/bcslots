class IncomingDeposit
  def transaction_type
    'deposit'
  end
  end
  def ids_dont_match!
    raise 'ids don\'t match'
  end
  def addresses_dont_match!
    raise 'addresses don\'t match'
  end
  def new_balance last_transaction_balance, change_in_balance
    BigDecimal(last_transaction_balance.to_s) + BigDecimal(change_in_balance.to_s)
  end
  def when_last_transaction_nil id, timestamp, address, deposit_amount
      {
        'id' => id,
        'address' => address,
        'timestamp' => timestamp,
        'credits' => credits,
        'payout' => payout_in_credits,
        'multiplier' => multiplier,
        'transaction_type' => transaction_type,
        'balance' => next_balance.to_s,
        'reels' => reels,
        'change_in_balance' => payout.to_s
      } 
  end
  def call args
    id = args['id']
    timestamp = args['timestamp']
    address = args['address']
    amount  = args['deposit_amount']

    last_transaction = args['last_transaction']
    last_id = last_transaction['id']
    address = last_transaction['address']
    last_transaction_balance = last_transaction['balance']
    last_transaction_type = last_transaction['transaction_type']

    payout_in_credits = reels_payout_in_credits reels, credits
    payout = reels_payout_in_satoshis reels, credits
    next_balance = new_balance last_transaction_balance, payout

    if last_id != id)
      ids_dont_match!
    if last_id != id
      ids_dont_match!
    else
      {
        'id' => id,
        'address' => address,
        'timestamp' => timestamp,
        'credits' => credits,
        'payout' => payout_in_credits,
        'multiplier' => multiplier,
        'transaction_type' => transaction_type,
        'balance' => next_balance.to_s,
        'reels' => reels,
        'change_in_balance' => payout.to_s
      } 
    end
  end
end


class IncomingBet
  def transaction_type
    'bet'
  end
  def possible_credits
    [1,2,3]
  end
  def multiplier
    0.05
  end
  def reels_payout_in_credits reels, credits
    p = Bcslots::Logic::DefaultPayout.new.call reels
    if (p < 0)
      p
    else
      p * credits
    end
  end
  def credits_to_value_in_satoshis credits
    BigDecimal.new(multiplier.to_s) * 100000000 * credits
  end
  def reels_payout_in_satoshis reels, credits
    credits_to_value_in_satoshis(reels_payout_in_credits(reels, credits))
  end
  def losing_bet_makes_balance_less_than_zero? last_transaction_balance
    0 > (BigDecimal(last_transaction_balance.to_s) - credits_to_value_in_satoshis(1))
  end
  def balance_less_than_zero!
    raise 'balance less than zero'
  end
  def ids_dont_match!
    raise 'ids don\'t match'
  end
  def credits_not_valid!
    raise 'credits not valid'
  end
  def last_transaction_withdrawal? last_transaction_type
    last_transaction_type == 'withdrawal'
  end
  def last_transaction_withdrawal!
    raise 'last transaction was withdrawal'
  end
  def credits_valid? possible_credits, credits
    possible_credits.include? credits
  end
  def new_balance last_transaction_balance, change_in_balance
    BigDecimal(last_transaction_balance.to_s) + BigDecimal(change_in_balance.to_s)
  end
  def call args
    id = args['id']
    timestamp = args['timestamp']
    credits = args['credits']
    reels = args['reels']

    last_transaction = args['last_transaction']
    last_id = last_transaction['id']
    address = last_transaction['address']
    last_transaction_balance = last_transaction['balance']
    last_transaction_type = last_transaction['transaction_type']

    payout_in_credits = reels_payout_in_credits reels, credits
    payout = reels_payout_in_satoshis reels, credits
    next_balance = new_balance last_transaction_balance, payout

    if not credits_valid? possible_credits, credits
      credits_not_valid!
    elsif losing_bet_makes_balance_less_than_zero? last_transaction_balance
      balance_less_than_zero!
    elsif last_id != id
      ids_dont_match!
    elsif last_transaction_withdrawal? last_transaction_type
      last_transaction_withdrawal!
    else
      {
        'id' => id,
        'address' => address,
        'timestamp' => timestamp,
        'credits' => credits,
        'payout' => payout_in_credits,
        'multiplier' => multiplier,
        'transaction_type' => transaction_type,
        'balance' => next_balance.to_s,
        'reels' => reels,
        'change_in_balance' => payout.to_s
      } 
    end
  end
end
