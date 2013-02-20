require 'SecureRandom'

module Reel

  def self.all_combinations reels
    combos = []
    reels.each do |first|
      reels.each do |second|
        reels.each do |third|
          combos << [first, second, third]
        end
      end
    end
    combos
  end





  def self.weighted_combinations reels, pattern_match
    weighted = []
    reels.each do |r|
      a = []
      pattern_match.call(r).times { a << r}
      weighted << a
    end
    weighted.inject([]){|x,y| x.concat(y)}
  end


  def self.new_patttern_match 
    yield CherriesCherriesCherriesBuilder.new
  end

  class ValidReelPatternMatchChecker
    def self.valid_arity! arity, block
      if not block.arity == arity
        raise "arity must be #{arity}" 
      end
    end
  end

  class Term
    attr_accessor :method_name, :is_last
  end

  #this stays in this module only!
  def self.define_pattern_builder class_name, next_class_name, arity, method_name
    eval <<-ev
    class #{class_name}Builder
      def initialize state
        @state = state
      end
      def #{method_name} &block
        ValidReelPatternMatchChecker.valid_arity! #{arity}, block
        @state[:#{method_name}] = block
    #{next_class_name}Builder.new @state
      end
    end
    ev
  end

  class CherriesCherriesCherriesBuilder
    def cherries_cherries_cherries &block
      ValidReelPatternMatchChecker.valid_arity! 0, block
      CherriesCherriesBarBuilder.new({:cherries_cherries_cherries => block})
    end
  end

  define_pattern_builder "CherriesCherriesBar", "CherriesCherriesAny", 0, "cherries_cherries_bar"
  define_pattern_builder "CherriesCherriesAny", "CherriesAnyAny",      1, "cherries_cherries_any"
  define_pattern_builder "CherriesAnyAny",      "OrangeOrangeOrange",  2, "cherries_any_any"
  define_pattern_builder "OrangeOrangeOrange",  "OrangeOrangeBar",     0, "orange_orange_orange"
  define_pattern_builder "OrangeOrangeBar",     "PlumPlumPlum",        0, "orange_orange_bar"
  define_pattern_builder "PlumPlumPlum",        "PlumPlumBar",         0, "plum_plum_plum"
  define_pattern_builder "PlumPlumBar",         "BellBellBell",        0, "plum_plum_bar"
  define_pattern_builder "BellBellBell",        "BellBellBar",         0, "bell_bell_bell"
  define_pattern_builder "BellBellBar",         "BarBarBar",           0, "bell_bell_bar"
  define_pattern_builder "BarBarBar",           "SevenSevenSeven",     0, "bar_bar_bar"
  define_pattern_builder "SevenSevenSeven",     "AnyOther",            0, "seven_seven_seven"
  define_pattern_builder "AnyOther",            "PatternMatch",        3, "any_other"

  class AnyOtherBuilder
    def initialize state
      @state = state
    end
    def any_other &block
      ValidReelPatternMatchChecker.valid_arity! 3, block
      @state[:any_other] = block
      PatternMatch.new @state
    end
  end

  class PatternMatch
    def initialize state
      @state = state
    end
    def valid! reels
      raise 'reels must be length 3' if not reels.length == 3
      correct_reels = reels.inject(true) {|x,y| x and PossibleReels.include?(y)}
      if not correct_reels
        raise 'reels must be from PossibleReels'
      end
    end
    def call reels
      valid! reels
      if reels == [:cherries, :cherries, :cherries]
        @state[:cherries_cherries_cherries].call
      elsif reels == [:cherries, :cherries, :bar]
        @state[:cherries_cherries_bar].call
      elsif reels[0..1] == [:cherries, :cherries]
        @state[:cherries_cherries_any].call reels[2]
      elsif reels[0] == :cherries
        @state[:cherries_any_any].call reels[1], reels[2]
      elsif reels == [:orange, :orange, :orange]
        @state[:orange_orange_orange].call
      elsif reels == [:orange, :orange, :bar]
        @state[:orange_orange_bar].call
      elsif reels == [:plum, :plum, :plum]
        @state[:plum_plum_plum].call
      elsif reels == [:plum, :plum, :bar]
        @state[:plum_plum_bar].call
      elsif reels == [:bell, :bell, :bell]
        @state[:bell_bell_bell].call
      elsif reels == [:bell, :bell, :bar]
        @state[:bell_bell_bar].call
      elsif reels == [:bar, :bar, :bar]
        @state[:bar_bar_bar].call
      elsif reels == [:seven, :seven, :seven]
        @state[:seven_seven_seven].call
      else
        @state[:any_other].call reels[0], reels[1], reels[2]
      end
    end
  end

  def self.weight
    new_patttern_match do |p|
      p
      .cherries_cherries_cherries {16}
      .cherries_cherries_bar      {16}
      .cherries_cherries_any  {|_| 32}
      .cherries_any_any     {|_,_| 64}
      .orange_orange_orange       {15}
      .orange_orange_bar          {15}
      .plum_plum_plum              {8}
      .plum_plum_bar               {8}
      .bell_bell_bell              {4}
      .bell_bell_bar               {4}
      .bar_bar_bar                 {2}
      .seven_seven_seven           {1}
      .any_other          {|_,_,_| 39}
    end
  end

  def self.payout
    new_patttern_match do |p|
      p
      .cherries_cherries_cherries {10}
      .cherries_cherries_bar      {10}
      .cherries_cherries_any   {|_| 5}
      .cherries_any_any      {|_,_| 2}
      .orange_orange_orange       {12}
      .orange_orange_bar          {12}
      .plum_plum_plum             {20}
      .plum_plum_bar              {20}
      .bell_bell_bell             {50}
      .bell_bell_bar              {50}
      .bar_bar_bar               {100}
      .seven_seven_seven         {250}
      .any_other          {|_,_,_| -1}
    end
  end
  def self.weighted
    weighted_combinations(AllCombinations, self.weight)
  end

  def self.random_reels
    WeightedCombinations[SecureRandom.random_number(WeightedCombinations.length)]
  end
  PossibleReels = [:cherries, :orange, :plum, :bell, :bar, :seven]
  AllCombinations = self.all_combinations(PossibleReels)
  WeightedCombinations = self.weighted
end
