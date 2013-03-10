require 'test_helper'

class SpinServiceTest < ActiveSupport::TestCase
  test 'valid_credits?' do
    (Array(-1000..0) + Array(4..1000)).each do |credits|
      assert (not SpinService.new.valid_credits? credits)
    end
  end

  test 'invalid credits return value' do
    assert (not SpinService.new.invalid_credits_return_value[:error].nil?)
  end

  test 'allowed_bet?' do
    bets = AllowedBet.pluck(:allowed_bet)
    data = Array(-1000..1000).collect{|x| BigDecimal(x.to_s) * 0.001.to_d}
    data = data - bets
    data.each do |bet|
      assert (not SpinService.new.allowed_bet? bet)
    end
  end

  test 'not allowed bet return value' do
    assert (not SpinService.new.not_allowed_bet_return_value[:error].nil?)
  end

  test 'get_newest_balance_change_for_user' do
    user = users(:user_with_one_deposit_of_one_bitcoin)
    bc = balance_changes(:first_deposit_for_a_user_with_one_bitcoin)
    result = SpinService.new.get_newest_balance_change_for_user user.public_id
    assert result['balance'] == bc.balance
    assert result['change']  == bc.change
  end

  test 'get_newest_balance_change_for_user nil if none' do
    user = users(:user_with_no_deposits)
    result = SpinService.new.get_newest_balance_change_for_user user.public_id
    assert result.nil?
  end

  test 'valid_balance_change?' do
    assert SpinService.new.valid_balance_change?([])
  end

  test 'no_previous_deposit_return_value' do
    assert (not SpinService.new.no_previous_deposit_return_value[:error].nil?)
  end

  test 'get_and_check_latest_balance_change when balance change valid' do 
    s = SpinService.new
    class << s
      def valid_balance_change? x
        true
      end
      def check_balance_before_payout_invariant x, y
        :called
      end
    end
    assert :called == s.get_and_check_latest_balance_change(nil, nil)
  end

  test 'get_and_check_latest_balance_change when balance change not valid' do 
    s = SpinService.new
    class << s
      def valid_balance_change? x
        false
      end
      def no_previous_deposit_return_value
        :called
      end
    end
    assert :called == s.get_and_check_latest_balance_change(nil, nil)
  end

  test 'total_bet' do 
    assert SpinService.new.total_bet(2, BigDecimal('7.0')).to_s == '14.0'
  end

  test 'value_of_losing_bet' do
    assert SpinService.new.value_of_losing_bet(BigDecimal('7.0')).to_s == '-7.0'
  end

  test 'check_balance_before_payout_invariant when lowest less than 0' do
    s = SpinService.new
    class << s
      def lowest_possible_balance_before_payout x, y
        -1
      end
      def lowest_possible_balance_too_low_return_value
        :called
      end
    end
    assert :called == s.check_balance_before_payout_invariant(nil, {:balance_change => nil})
  end

  test 'check_balance_before_payout_invariant when lowest at least 0' do
    s = SpinService.new
    class << s
      def lowest_possible_balance_before_payout x, y
        0
      end
      def get_random_reels_and_cont x, y
        :called
      end
    end
    assert :called == s.check_balance_before_payout_invariant(nil, {:balance_change => nil})
  end

  test 'lowest_possible_balance_too_low_return_value' do
    assert (not SpinService.new.lowest_possible_balance_too_low_return_value[:error].nil?)
  end

  test 'lowest_possible_balance_before_payout' do
    s = SpinService.new
    class << s
      def value_of_losing_bet x
        BigDecimal('-4.0')
      end
    end
    assert s.lowest_possible_balance_before_payout(BigDecimal('7.0'), BigDecimal('4.0')).to_s == '0.0'
  end

  test 'get_random_reels' do
    r = SpinService.new.get_random_reels
    assert (not r[:reels].nil?)
    assert (not r[:payout].nil?)
    assert (not r[:weight].nil?)
  end

  test 'get_random_reels_and_cont' do
    s = SpinService.new
    class << s
      def write_to_db x, y, z
        :done
      end
    end
    assert :done == s.get_random_reels_and_cont(BigDecimal('1.0'), BigDecimal('1.0'))
  end

  test 'bet_balance_change_type' do
    assert SpinService.new.bet_balance_change_type.balance_change_type == 'bet'
  end

  test 'change_in_balance' do
    assert SpinService.new.change_in_balance(BigDecimal('7.0'),2).to_s == '14.0'
  end

  test'write_to_db' do
  end

  test 'output_values' do
    s = SpinService.new
    class << s
      def lowest_possible_balance_before_payout x, y
        BigDecimal('9.0')
      end
    end
    output = s.output_values BigDecimal('1.0'), BigDecimal('2.0'), ['cherries', 'cherries', 'cherries'], BigDecimal('3.0'), BigDecimal('1.0')
    assert output[:previous_balance] == '2.0'
    assert output[:balance] == '3.0'
    assert output[:balance_in_dBTC] == '30'
    assert output[:balance_in_cBTC] == '300'
    assert output[:balance_in_mBTC] == '3000'
    assert output[:reels] == ['cherries', 'cherries', 'cherries']
    assert output[:payout] == '1.0'
    assert output[:balance_before_payout_in_dBTC] == '90'
    assert output[:balance_before_payout_in_cBTC] == '900'
    assert output[:balance_before_payout_in_mBTC] == '9000'
  end

  #TODO: move to functional
  #  test 'get_random_reels has negative expectedd value' do
  #    s = SpinService.new
  #    payout = 0
  #   trials = 1000
  #    trials.times do |i|
  #      payout += s.get_random_reels[:payout]
  #    end
  #    expected value = payout.to_f / trials
  #    assert expected_value < 0
  #
end
