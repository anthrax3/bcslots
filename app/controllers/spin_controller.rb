require 'SecureRandom'

class SpinController < ApplicationController
  respond_to :xml
  def create 
    @data = SpinService.new.record_spin params[:id], params[:credits], params[:credit_value]
  end
end

class SpinService
  def number_of_positions
    ActiveRecord::Base.connection
    .execute('select sum(weight) from reel_combinations rc join conditional_reel_combinations crc on crc.id = rc.conditional_reel_combination_id;')
    .first["sum"]
    .to_i
  end
  def reels_and_payout_from_position position
    query = <<-q
      select first, second, third, payout, weight, reel_combination_id from
       (select payout,
               weight,
               rc.id as reel_combination_id,
               first.reel  as first,
               second.reel as second,
               third.reel  as third,
               sum(weight) over (order by rc.id) - weight as min,
               sum(weight) over (order by rc.id) - 1      as max
        from reel_combinations rc
        join conditional_reel_combinations crc on crc.id = rc.conditional_reel_combination_id
        join reels first  on first.id  = rc.first_id
        join reels second on second.id = rc.second_id
        join reels third  on third.id  = rc.third_id
       ) q
      where min <= ? and ? <= max 
    q
    result = ReelCombination.find_by_sql([query, position, position]).first.attributes
    {:payout => result['payout'].to_i,
     :weight => result['weight'].to_i,
     :reel_combination_id => result['reel_combination_id'],
     :reels => [result['first'], result['second'], result['third']]}
  end
  def random_number
    SecureRandom.random_number number_of_positions
  end
  def random_reels
    reels_and_payout_from_position random_number
  end
  def allowed_bets
    AllowedBet.pluck(:allowed_bet)
  end
  def record_spin public_id, credits, credit_value
    ActiveRecord::Base.transaction do
      if not [1,2,3].include? credits.to_i
        return {:error => 'invalid credits'}
      end
      if not allowed_bets.include? credit_value.to_d
        return {:error => 'invalid credit value'}
      end

      bet = credits.to_i * credit_value.to_d

      bc = BalanceChange
      .newest_for_user_with_public_id(public_id.to_s)
      .select('balance_changes.*')
      .first

      if bc.nil?
        return {:error => 'no previous deposit', :balance => BigDecimal(0.to_s).to_s}
      end

      any_other = ConditionalReelCombination.where(:condition => 'any other').first!
      balance_before_payout = bc.balance + any_other.payout * bet.to_d
      if balance_before_payout < 0
        return {:error => 'balance too low for bet', :balance => bc.balance.to_s}
      end

      result = random_reels

      next_bc = BalanceChange.new
      next_bc.balance_change_type = BalanceChangeType.where(:balance_change_type => 'bet').first!
      next_bc.change = result[:payout] * bet.to_d
      next_bc.balance = bc.balance + next_bc.change
      next_bc.user_id = bc.user_id

      next_bc.bet = Bet.new
      next_bc.bet.current_payout = result[:payout]
      next_bc.bet.current_weight = result[:weight]
      next_bc.bet.reel_combination_id = result[:reel_combination_id]

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
