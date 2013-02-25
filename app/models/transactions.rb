class TransactionCollection
  def initialize id
    @id = id
  end
  def id
    @id
  end
  def list_name 
    "transactions_#{id}"
  end
  def redis_client
    @client ||= Redis.new
  end
  def redis_list_at_0
    redis_client.linex list_name 0
  end
  def parse_data data
    JSON.parse data, :symbol_names => true
  end
  def first_element_parsed
    parse_data redis_list_at_0
  end
  def transaction_deposit? data
    data[:transaction_type] == 'deposit'
  end
  def first_transaction_deposit?
    transaction_deposit? first_element_parsed
  end
  def empty?
    redis_list_at_0.nil?
  end
  def add_new data
    redis_client.lpush list_name data.to_s
  end
end

class Transaction
  attr_reader :timestamp, :address, :id, :current_balance, :transaction_type
end

#spin data:
#user id
#amount bet
#
module IncomingSpin
  def id
    params[:id]
  end
  def transaction_collection
    @transaction_collection ||= TransactionCollection.new self.id
  end
  def first_transaction_deposit?
    transaction_collection.first_transaction_deposit?
  end
  def at_least_one_transaction?
    not transaction_collection.empty?
  end
  def at_least_one_deposit?
    at_least_one_transaction? and first_transaction_deposit?
  end
  def at_least_one_transaction!
  end
  def verify_at_least_one_transaction
    at_least_one_transaction! if not 
  end
  def add_new_spin_if_valid spin
    at

end
