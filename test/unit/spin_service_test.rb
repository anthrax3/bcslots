require 'test_helper'

class SpinServiceTest < ActiveSupport::TestCase
  test "only allows bet sizes of 1,2,3" do
    bet = AllowedBet.pluck(:allowed_bet).first
    user = users(:user_with_one_deposit_of_one_bitcoin)

    Array(-1000..0) + Array(4..1000).each do |credits|
      result = SpinService.new.execute user.public_id, credits, bet
      if result[:error] == 'invalid credits' && user.balance_changes.count == 1
        assert true
      else
        binding.pry
      end
    end
  end

  test "only allows valid bet values" do
    bets = AllowedBet.pluck(:allowed_bet)
    user = users(:user_with_one_deposit_of_one_bitcoin)
    data = Array(-1000..1000).collect{|x| BigDecimal(x.to_s) * 0.001.to_d}
    data = data - bets
      data.each do |bet|
        result = SpinService.new.execute user.public_id, 1, bet
        if result[:error] == 'invalid credit value' && user.balance_changes.count == 1
          assert true
        else
          binding.pry
        end
      end
  end

  test "valid bet adds to database" do
    bet = AllowedBet.pluck(:allowed_bet).first
    user = users(:user_with_one_deposit_of_one_bitcoin)
    result = SpinService.new.execute user.public_id, 1, bet
    assert user.balance_changes.count == 2
  end
end
