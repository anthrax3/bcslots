require 'test_helper'

class ConditionalReelCombinationsTest < ActiveSupport::TestCase
  test "expected value is less than 0 and greater than -0.02" do
    payouts = ConditionalReelCombination
    .all
    .collect do |x|
      x.reel_combinations.collect {x.payout} * x.weight
    end
    .flatten
    expected_value = payouts.sum / payouts.count.to_f
    assert (expected_value > -0.02 && expected_value < 0)
  end
end
