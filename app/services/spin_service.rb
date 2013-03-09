require 'SecureRandom'

class SpinService
  def random_number max_non_inclusive
    SecureRandom.random_number max_non_inclusive
  end
  def valid_credits? credits
      [1,2,3].include? credits.to_i
  end
  def invalid_credits_return_value
    {:error => 'invalid credits'}
  end
  def allowed_bet? bet_value
    AllowedBet.allowed_bets.include? bet_value.to_d
  end
  def not_allowed_bet_return_value
    {:error => 'invalid credits'}
  end
  def get_newest_balance_change_for_user public_id
      BalanceChange
      .newest_for_user_with_public_id(public_id.to_s)
      .select('balance_changes.*')
      .first
      .try(:attributes)
  end
  def valid_balance_change? balance_change
    balance_change.nil?
  end
  def no_previous_deposit_return_value
      {:error => 'no previous deposit'}
  end
  def get_and_check_latest_balance_change total_bet, public_id
    bc = get_newest_balance_change_for_user public_id
    if valid_balance_change? bc
      check_balance_befor_payout_invariant total_bet, bc
    else
      no_previous_deposit_return_value
    end
  end
  def check_credits_and_bet_value_invariants credits, bet_value, public_id
    if not valid_credits? credits
      invalid_credits_return_value
    else if not allowed_bet? bet_value
      not_allowed_bet_return_value
    else 
      get_and_check_latest_balance_change total_bet(credits, bet_value), public_id
    end
  end
  def total_bet credits, bet_value
    credits.to_i * credit_value.to_d
  end
  def value_of_losing_bet total_bet
    -1 * total_bet
  end
  def check_balance_before_payout_invariant total_bet, balance_change
    lowest = lowest_possible_balance_before_payout total_bet, balance_change[:balance]
    if lowest < 0
      lowest_possible_balance_too_low_return_value
    else
      get_random_reels_and_cont total_bet, balance_change
    end
  end
  def lowest_possible_balance_too_low_return_value
    {:error => 'balance too low for bet'}
  end
  def lowest_possible_balance_before_payout total_bet, balance
    value_of_losing_bet(total_bet) + balance
  end
  def get_random_reels
    r = ReelCombination.weighted_reel_combinations
    r[random_number(r.length)]
  end
  def get_random_reels_and_cont total_bet, balance_change
    reels = get_random_reels
    write_to_db total_bet, balance_change, reels
  end
  def bet_balance_change_type
    BalanceChangeType.balance_change_types.find{|x| x == 'bet'}
  end
  def change_in_balance total_bet, payout
    total_bet.to_d * payout.to_i
  end
  def write_to_db total_bet, balance_change, reels
    ActiveRecord::Base.transaction do

      next_bc = BalanceChange.new
      next_bc.balance_change_type = balance_change_type
      next_bc.change = change_in_balance(total_bet, reels[:payout])
      next_bc.balance = bc.balance.to_d + next_bc.change.to_d
      next_bc.user_id = bc.user_id

      next_bc.bet = Bet.new
      next_bc.bet.current_payout = result[:payout].to_i
      next_bc.bet.current_weight = result[:weight].to_i
      next_bc.bet.reel_combination_id = result[:reel_combination_id]

      bc.next = next_bc

      next_bc.save!
      bc.save!
    end
    output_values total_bet, balance_change.balance, reels, next_bc.balance, next_bc.change
  end
  def output_values total_bet, previous_balance, reels, next_balance, payout
    before_payout = lowest_possible_balance_before_payout(total_bet, balance_change[:balance]).to_d
    {
     :previous_balance => previous_balance.to_d.to_s, 
     :balance => next_balance.to_d.to_s,
     :balance_in_dBTC => (next_balance.to_d * 10).to_i.to_s,
     :balance_in_cBTC => (next_balance.to_d * 100).to_i.to_s,
     :balance_in_mBTC => (next_balance.to_d * 1000).to_i.to_s,
     :reels => result[:reels],
     :payout => payout.to_d.to_s,
     :balance_before_payout_in_dBTC => (before_payout * 10).to_i.to_s,
     :balance_before_payout_in_cBTC => (before_payout * 100).to_i.to_s,
     :balance_before_payout_in_mBTC => (before_payout * 1000).to_i.to_s
    }
  end
  def execute public_id, credits, bet_value
    check_credits_and_bet_value_invariants credits, bet_value, public_id
  end
end