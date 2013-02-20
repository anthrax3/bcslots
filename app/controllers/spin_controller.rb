class SpinController < ApplicationController
  respond_to :xml
  def show 
    @reels = Reel.random_reels
    respond_with @reels
  end
end
