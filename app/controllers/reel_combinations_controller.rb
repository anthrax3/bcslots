class ReelCombinationsController < ApplicationController
  include SuperSimpleAuth
  respond_to :csv
  def index
    @data = ReelCombination.weighted_reel_combinations
  end
end


