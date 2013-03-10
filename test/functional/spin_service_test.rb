require 'test_helper'

class SpinServiceTest < ActiveSupport::TestCase
  test 'does not allow invalid credits' do
    user = users(:user_with_no_deposits)
    bet = AllowedBet.allowed_bets.first
    [0,4,5,6,-1,-2,-3,'a''hi',{:a => :malicious}].each do |credits|
      r = SpinService.new.execute user.public_id, credits, bet
      assert (not r[:error].nil?)
      assert user.balance_changes.count == 0
    end
  end

  test 'does not allow invalid bet values' do
    user = users(:user_with_no_deposits)
    bet = AllowedBet.allowed_bets.first
    [0.to_f.to_d, 0.4.to_d, 0.5, 6,-0.2.to_d,-3.0.to_d,'a''hi',{:a => :malicious}].each do |credits|
      r = SpinService.new.execute user.public_id, credits, bet
      assert (not r[:error].nil?)
      assert user.balance_changes.count == 0
    end
  end

  test 'user with no previous deposit can\'t bet' do
    user = users(:user_with_no_deposits)
    bet = AllowedBet.allowed_bets.first
    r = SpinService.new.execute user.public_id, 1, bet
    assert (not r[:error].nil?)
    assert user.balance_changes.count == 0
  end

  test 'does not allow a larger bet than the user could cover' do
    user = users(:user_with_one_deposit_of_one_d_bitcoin)
    r = SpinService.new.execute user.public_id, 2, '0.1'
    assert (not r[:error].nil?)
    assert user.balance_changes.count == 1
  end

  test 'user wins' do
    user = users(:user_with_one_deposit_of_one_d_bitcoin)
    s = SpinService.new
    class << s
      def get_random_reel_combination
        ReelCombination.weighted_reel_combinations.find{|x| x[:payout] == 1}
      end
    end
    r = s.execute user.public_id, 1, '0.1'
    assert user.balance_changes.count == 2
    assert r[:previous_balance] == '0.1'
    assert r[:balance] == '0.2'
    assert r[:balance_in_dBTC] == '2'
    assert r[:balance_in_cBTC] == '20'
    assert r[:balance_in_mBTC] == '200'
    assert (not r[:reels].nil?)
    assert r[:payout] == '0.1'
    assert r[:balance_before_payout_in_dBTC] == '0'
    assert r[:balance_before_payout_in_cBTC] == '0'
    assert r[:balance_before_payout_in_mBTC] == '0'
  end

  test 'get_random_reel_combination has expected value < 0' do
    s = SpinService.new
    payout = 0
    trials = 1000
    trials.times do |i|
      puts "trial #{i}"
      payout += s.get_random_reel_combination[:payout]
    end
    expected_value = payout.to_f / trials
    assert (expected_value < 0), "expected value is #{expected_value}"
  end
end
#TODO: move to functional

