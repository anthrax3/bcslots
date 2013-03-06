class SpinController < ApplicationController
  respond_to :xml
  def create 
    @data = SpinService.new.record_spin params[:id], params[:bet]
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
      select first, second, third, payout from
       (select payout,
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
    {:payout => result['payout'], :reels => [result['first'], result['second'], result['third']]}
  end
  def get_random_reels
    Bcslots::Logic::Reels.new.random_reels
  end
  def get_allowed_bets
    AllowedBet.pluck(:allowed_bet)
  end
  def record_spin public_id, bet
    ActiveRecord::Base.transaction do
      if not get_allowed_bets.include? bet.to_d
        return {:error => 'invalid bet amount'}
      end

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

      reels = get_random_reels
      conditional_reel_combination = ConditionalReelCombination
      .find_by_reels(reels)
      .select('weight, payout, reel_combinations.id as reel_combination_id')
      .first!

      next_bc = BalanceChange.new
      next_bc.balance_change_type = BalanceChangeType.where(:balance_change_type => 'bet').first!
      #TODO: check stats again
      next_bc.change = conditional_reel_combination.payout * bet.to_d
      next_bc.balance = bc.balance + next_bc.change
      next_bc.user_id = bc.user_id

      next_bc.bet = Bet.new
      next_bc.bet.current_payout = conditional_reel_combination.payout
      next_bc.bet.current_weight = conditional_reel_combination.weight
      next_bc.bet.reel_combination_id = conditional_reel_combination.reel_combination_id

      bc.next = next_bc

      next_bc.save!
      bc.save!
      {:previous_balance => bc.balance.to_s, :balance => next_bc.balance.to_s, :reels => reels, :payout => next_bc.change.to_s, :balance_before_payout => balance_before_payout.to_s}
    end
  end
end
