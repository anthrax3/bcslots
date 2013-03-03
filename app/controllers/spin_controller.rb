class SpinController < ApplicationController
  respond_to :xml
  def show 
    binding.pry
    ActiveRecord::Base.transaction do
      @reels = Bcslots::Logic::Reels.new.random_reels
      changes = BalanceChange.find_by_sql(['select bc.balance from balance_changes bc where bc.user_id = (select u.id from users u where u.public_id = ?) and bc.next_id is NULL', params[:id].to_s])
      if changes.empty?
      elsif changes.count > 1
        raise "SpinController: too many NULL next ids for public id #{params[:id]}" 
      else
        change = changes[0]



    end
      respond_with @reels
  end
end
