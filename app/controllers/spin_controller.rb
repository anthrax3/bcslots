class SpinController < ApplicationController
  respond_to :xml
  def create 
    @data = SpinService.new.record_spin params[:id], params[:bet]
  end
end

class SpinService
  def get_random_reels
    Bcslots::Logic::Reels.new.random_reels
  end
  def record_spin public_id, bet
    ActiveRecord::Base.transaction do
      if not AllowedBet.pluck(:allowed_bet).include? bet.to_d
        raise 'invalid bet amount'
      end

      bc = BalanceChange
      .newest_for_user_with_public_id(public_id.to_s)
      .select('balance_changes.*')
      .first

      if bc.nil?
        raise 'no desposit'
      end

      any_other = ConditionalReelCombination.where(:condition => 'any other').first!
      if (bc.balance + any_other.payout * bet.to_d) < 0
        raise 'balance too low for bet'
      end

      reels = get_random_reels
      conditional_reel_combination = ConditionalReelCombination
      .find_by_reels(reels)
      .select('weight, payout, reel_combinations.id as reel_combination_id')
      .first!

      next_bc = BalanceChange.new
      next_bc.balance_change_type = BalanceChangeType.where(:balance_change_type => 'bet').first!
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
      {:balance => next_bc.balance.to_s, :reels => reels}
    end
  end
end
