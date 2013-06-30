#require 'SecureRandom'

class SpinService
  def get_random_reel_combination user_id, user_position
    pfo = ProvablyFairOutcome.where(:user_id => user_id).first
    if pfo.nil?
      pfo = ProvablyFairOutcome.add_provably_fair_outcome_for_user_id user_id, ReelCombination.weighted_reel_combinations.size
    end
    rcs = ReelCombination.weighted_reel_combinations
    our_pos = pfo.position
    pos = (user_position + our_pos) % ReelCombination.weighted_reel_combinations.size
    rcs[pos]
  end
  def execute public_id, credits, bet_value, user_position
    ActiveRecord::Base.transaction do
      if (not [1,2,3].include? credits.to_i)
        return {:error => 'invalid credits'}
      end
      if not AllowedBet.pluck(:allowed_bet).include? bet_value.to_d
        return {:error => 'invalid bet value'}
      end

      if not (user_position.to_i >= 0 && user_position.to_i <= ReelCombination.weighted_reel_combinations.size)
        return {:error => 'invalid user position'}
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


      result = get_random_reel_combination bc.user_id, user_position.to_i

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

      p = ProvablyFairOutcome.where(:user_id => bc.user_id).first!
      secret = p.secret
      position = p.position
      current_hash = p.to_hash_for_user
      p.destroy

      p_next = ProvablyFairOutcome.add_provably_fair_outcome_for_user_id bc.user_id, ReelCombination.weighted_reel_combinations.size
      next_hash = p_next.to_hash_for_user

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
        :balance_before_payout_in_mBTC => (balance_before_payout * 1000).to_i.to_s,
        :secret => secret,
        :position => position,
        :current_hash => current_hash,
        :next_hash => next_hash
      }
    end
  end
end
