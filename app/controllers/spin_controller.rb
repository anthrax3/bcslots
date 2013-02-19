class SpinController < ApplicationController
  respond_to :xml
  def show 
    @reels = [1,2,3]
    respond_with reels
  end
end
