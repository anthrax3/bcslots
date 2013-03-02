class SpinController < ApplicationController
  respond_to :xml
  def show 
    binding.pry
    ActiveRecord::Base.transaction do
      @reels = Bcslots::Logic::Reels.new.random_reels
    end
      respond_with @reels
  end
end
