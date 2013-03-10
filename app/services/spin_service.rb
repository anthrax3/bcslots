require 'SecureRandom'

class SpinService
  def get_random_reel_combination
    rcs = ReelCombination.weighted_reel_combinations
    pos = SecureRandom.random_number rcs.size
    rcs[pos]
  end
  def execute public_id, credits, bet_value
    ActiveRecord::Base.transaction do
      if (not credits.is_a? Fixnum) || (not [1,2,3].include? credits.to_i)
        return {:error => 'invalid credits'}
      end
      if not AllowedBet.pluck(:allowed_bet).include? bet_value.to_d
        return {:error => 'invalid bet value'}
      end

      bet = credits.to_i * bet_value.to_d

      bc = BalanceChange
      .newest_for_user_with_public_id(public_id.to_s)
      .select('balance_changes.*')
      .first

      if bc.nil?
        return {:error => 'no previous deposit'}
      end

      any_other = ConditionalReelCombination.where(:condition => 'any other').first!
      balance_before_payout = bc.balance + any_other.payout * bet.to_d
      if balance_before_payout < 0
        return {:error => 'balance too low for bet'}
      end

      result = get_random_reel_combination

      next_bc = BalanceChange.new
      next_bc.balance_change_type = BalanceChangeType.where(:balance_change_type => 'bet').first!
      next_bc.change = result[:payout] * bet.to_d
      next_bc.balance = bc.balance + next_bc.change
      next_bc.user_id = bc.user_id

      next_bc.bet = Bet.new
      next_bc.bet.current_payout = result[:payout]
      next_bc.bet.current_weight = result[:weight]
      next_bc.bet.reel_combination_id = result[:id]

      bc.next = next_bc

      next_bc.save!
      bc.save!
      {
       :previous_balance => bc.balance.to_s, 
       :balance => next_bc.balance.to_s,
       :balance_in_dBTC => (next_bc.balance * 10).to_i.to_s,
       :balance_in_cBTC => (next_bc.balance * 100).to_i.to_s,
       :balance_in_mBTC => (next_bc.balance * 1000).to_i.to_s,
       :reels => result[:reels],
       :payout => next_bc.change.to_s,
       :balance_before_payout_in_dBTC => (balance_before_payout * 10).to_i.to_s,
       :balance_before_payout_in_cBTC => (balance_before_payout * 100).to_i.to_s,
       :balance_before_payout_in_mBTC => (balance_before_payout * 1000).to_i.to_s
      }
    end
  end
end
