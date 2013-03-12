#require 'securerandom'

module HumanId
  def maximum_length
    13
  end
  def minimum_length
    13 
  end
  def base
    36
  end
  def unwanted_characters
    ['l','1','o','0','2','z', 'u', 'v', 'w']
  end
  def lower_random_bound
    base ** (minimum_length - 1)
  end
  def upper_random_bound
    base ** maximum_length
  end
  def random_number n
    SecureRandom.random_number n
  end
  def random_between_lower_and_upper_bound
    random_number(upper_random_bound - lower_random_bound)
  end
  def random_between_lower_and_upper_bound_to_base_string
    r = random_between_lower_and_upper_bound
    random_to_base_string r
  end
  def random_to_base_string r
    r.to_s base
  end
  def single_random_character
    r = random_number base
    random_to_base_string r 
  end
  def unacceptable_character? r 
    unwanted_characters.include? r
  end
  def acceptable_character
    r = single_random_character
    if (unacceptable_character? r)
      acceptable_character
    else
      r
    end
  end
  def replace_unacceptable_character c
    if unacceptable_character? c
      acceptable_character
    else
      c
    end
  end
  def map_over_string s, &block
    t = ''
    s.each_char do |c|
      d = block.call c
      t << d
    end
    t
  end
  def acceptable_random_string_between_lower_and_upper_bound
    r = random_between_lower_and_upper_bound_to_base_string
    map_over_string(r) {|x| replace_unacceptable_character x}
  end
  def generate_human_id
    acceptable_random_string_between_lower_and_upper_bound
  end
end
