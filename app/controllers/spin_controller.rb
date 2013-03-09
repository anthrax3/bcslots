require 'SecureRandom'

class SpinController < ApplicationController
  respond_to :xml
  def create 
    @data = SpinService.new.record_spin params[:id], params[:credits], params[:credit_value]
  end
end
