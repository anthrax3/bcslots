class SpinController < ApplicationController
  respond_to :xml
  def create 
    @data = SpinService.new.execute params[:id], params[:credits], params[:credit_value], params[:user_position]
  end
end
