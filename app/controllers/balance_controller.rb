class BalanceController < ApplicationController
  respond_to :json
  def show
    bc = BalanceChange
    .newest_for_user_with_public_id(params[:id].to_s)
    .select('balance')
    .first

    if bc.nil?
      @data = {
        :balance => 0.to_s,
        :balance_in_dBTC => 0.to_s,
        :balance_in_cBTC => 0.to_s,
        :balance_in_mBTC => 0.to_s
      }
    else
      @data = {
        :balance => bc.balance.to_s,
        :balance_in_dBTC => (bc.balance * 10).to_i.to_s,
        :balance_in_cBTC => (bc.balance * 100).to_i.to_s,
        :balance_in_mBTC => (bc.balance * 1000).to_i.to_s
      }
    end
  end
end
