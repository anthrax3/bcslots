class SpinController < ApplicationController
  respond_to :xml
  def show 
    SpinService.new.record_spin params[:id], params[:credits]
    binding.pry
  end
end

class SpinService
  def get_random_reels
    Bcslots::Logic::Reels.new.random_reels
  end
  def record_spin public_id, credits
    ActiveRecord::Base.transaction do
      bc = BalanceChange
      .newest_for_user_with_public_id(public_id.to_s)
      .select('balance_changes.*')
      .first

      if bc.nil?
        raise 'no desposit'
      end

      multiplier = Multiplier.first!.multiplier
      any_other = ConditionalReelCombination.where(:condition => 'any other').first!
      if (bc.balance + credits * any_other.payout * multiplier) < 0
        raise 'not enough credits'
      end

      reels = get_random_reels
      conditional_reel_combination = ConditionalReelCombination
      .find_by_reels(reels)
      .select('weight, payout, reel_combinations.id as reel_combination_id')
      .first!

      next_bc = BalanceChange.new
      next_bc.balance_change_type = BalanceChangeType.where(:change_type => 'bet').first!
      next_bc.change = conditional_reel_combination.payout * multiplier * credits
      next_bc.balance = bc.balance + next_bc.change
      next_bc.user_id = bc.user_id

      next_bc.bet = Bet.new
      next_bc.bet.current_multiplier = multiplier
      next_bc.bet.current_payout = conditional_reel_combination.payout
      next_bc.bet.current_weight = conditional_reel_combination.weight
      next_bc.bet.credits = credits.to_i
      next_bc.bet.reel_combination_id = conditional_reel_combination.reel_combination_id

      next_bc.save!

      bc.next = next_bc
      bc.save!
    end
  end
end
