class SpinController < ApplicationController
  respond_to :xml
  def show 
    binding.pry
    ActiveRecord::Base.transaction do
      bc = BalanceChange.includes(:user)
          .where('users.public_id' => params[:id].to_s)
          .where(:next_id => nil).first

      if bc.nil?
        #user has never deposited
      else

        multiplier = Multiplier.first
        any_other = ConditinalReelCombination.where(:condition => 'any other').first!
        if (bc.balance + any_other.payout * multiplier) >= 0

          @reels = Bcslots::Logic::Reels.new.random_reels
          reels_payout = ConditionalReelCombination
                         .find_by_reels(@reels)
                         .select('payout')
                         .first!
                         .payout

          next_bc = BalanceChange.new
          next_bc.balance_change_type = BalanceChangeType.where(:change_type => 'bet').first!
          next_bc.change = new_payout * multiplier
          next_bc.balance = change.balance + bc.change
          #to get past null condition
          next_bc.next = bc



          #not enough cash
        end




      end
      respond_with @reels
    end
  end
