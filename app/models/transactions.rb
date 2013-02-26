class Transaction
  attr_accessor :id
  def initialize id
    self.id = id
  end
  def list_name 
    "transactions_#{self.id}"
  end
  def redis_client
    @redis_client ||= Redis.new
  end
  def at_transaction num
    redis_client.lindex list_name, num
  end
  def first_transaction
    at_transaction 0
  end
  def parse_data data
    JSON.parse data
  end
  def first_transaction_parsed
    parse_data first_transaction
  end
  def transaction_deposit? data
    data['transaction_type'] == 'deposit'
  end
  def first_transaction_deposit?
    transaction_deposit? first_transaction_parsed
  end
  def at_least_one_deposit?
    at_least_one_transaction? and first_transaction_deposit?
  end
  def at_least_one_transaction?
    not first_transaction.nil?
  end
  def last_transaction_unparsed
    at_transaction -1
  end
  def last_transaction
    parse_data last_transaction_unparsed
  end
  def last_transaction_balance
    last_transaction['balance']
  end
  def last_transaction_balance_in_satoshis
    last_transaction_balance
  end
  def address_for_id
    redis_client.get id
  end
  def has_address?
    not address_for_id.nil?
  end
  def add_new data
    redis_client.lpush list_name, data.to_json
  end
end

class Transaction
  attr_accessor :timestamp, :address, :id, :current_balance, :transaction_type
end



#spin data:
#user id
#amount bet
#
#


class IncomingSpin
  attr_accessor :id, :credits_bet
  def initialize id, credits_bet
    self.id = id
    self.credits_bet = credits_bet
  end
  def invariants_not_met
    raise 'implement'
  end
  def multiplier
    raise 'implement'
  end
  def transaction
    @transaction = Transaction.new id
  end
  def at_least_one_deposit?
    transaction.at_least_one_deposit?
  end
  def has_address?
    transaction.has_address?
  end
  def last_transaction_balance_in_satoshis
    transaction.last_transaction_balance_in_satoshis
  end
  def add_new data
    transaction.add_new data
  end
  def random_reels
    Bcslots::Logic::Reels.new.random_reels
  end
  def random_result_value_in_credits reels
    Bcslots::Logic::DefaultPayout.new.call reels
  end
  def possible_credits_bet
    [1,2,3]
  end
  def credits_bet_combined_with_random_result_in_credits reels
    r = random_result_value_in_credits reels
    if (r > 0)
      r * credits_bet
    else
      r
    end
  end
  def combined_credit_outcome_to_satoshis_at_one_credit_per_bitcoin reels
    credits_bet_combined_with_random_result_in_credits(reels) * 100000000
  end
  def amount_changing_in_satoshis reels
    combined_credit_outcome_to_satoshis_at_one_credit_per_bitcoin(reels) * multiplier
  end
  def result_balance_in_satoshis
    last_transaction_balance_in_satoshis - amount_changing_in_satoshis
  end
  def result_balance_at_least_0?
    result_balance_in_satoshis > 0
  end
  def credits_bet_valid?
    possible_credits_bet.include? credits_bet
  end
  def all_invariants_met?
    has_address? and at_least_one_deposit? and credits_bet_valid? and result_balance_at_least_0?
  end
  def to_transaction
    {'id' => id,
      'timestamp' => Time.now,
      'credits_bet' => credits_bet,
      'transaction_type' => 'bet',
      'balance_in_satoshis' => result_balance_in_satoshis,
      'reels' => generate_or_get_random_reels,
      'change_in_balace_in_satoshis' => amount_changing_in_satoshis} 
  end
  def to_transaction_and_add_to_redis
    add_new to_transaction
  end
  def add_new_bet
    if all_invariants_met?
      to_transaction_and_add_to_redis
    else
      invariants_not_met
    end
  end
end

class Coolness < IncomingSpin
  def add_new_bet
    to_transaction_and_add_to_redis
  end
  def multiplier
    1
  end
  def last_transaction_balance_in_satoshis
    if not at_least_one_deposit?
      100000000
    else
      last_transaction_balance_in_satoshis
    end
  end
end
