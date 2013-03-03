class SpinController < ApplicationController
  respond_to :xml
  def show 
    binding.pry
    ActiveRecord::Base.transaction do
      changes = BalanceChange.find_by_sql(['select bc.balance, bc.user_id from balance_changes bc where bc.user_id = (select u.id from users u where u.public_id = ?) and bc.next_id is NULL', params[:id].to_s])
      if changes.empty?
        #user has never deposited
      else
        #postgres ensures there will be no more than one
        change = changes[0]
        #TODO: put this in the db
        multiplier = 1
        negative_payout = ConditionalReelCombination.find_by_sql("select payout from conditional_reel_combinations where condition = 'any other'")[0].payout
        if (change.balance + negative_payout * multiplier) >= 0
          @reels = Bcslots::Logic::Reels.new.random_reels
          payout_query = <<-q
                  select payout from conditional_reel_combinations crc
                  join reel_combinations rc on rc.conditional_reel_combination_id = crc.id 
                  join reels r1 on r1.id = rc.first_id 
                  join reels r2 on r2.id = rc.second_id
                  join reels r3 on r3.id = rc.third_id
                  where r1.reel = ? and r2.reel = ? and r3.reel = ?
                  q

          new_payout = ConditionalReelCombination.find_by_sql([payout_query, @reels[0], @reels[1], @reels[2])[0].payout
          bc = BalanceChange.new

          #not enough cash
        end




      end
      respond_with @reels
    end
  end
