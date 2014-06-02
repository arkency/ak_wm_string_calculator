require 'test/unit'

class StringCalculatorTest < Test::Unit::TestCase
  def test_adding
    assert_add(0, "")
    assert_add(1, "1")
    assert_add(3, "1,2")
    assert_add(10, "1,2,3,4")
    assert_add(6, "1\n2,3")
    assert_add(10, "1\n2\n3\n4")
    assert_add(5, "//*\n4*1")
    assert_raise_with_message Calculator::NegativesNotAllowed, 'negatives are not allowed: -1' do
      calc.add("1,-1")
    end
    assert_raise_with_message Calculator::NegativesNotAllowed, 'negatives are not allowed: -1, -5, -7' do
      calc.add("1,-1,2,3,4,-5,-7")
    end
  end

  private
  def assert_add(expected, expression)
    assert_equal(expected, calc.add(expression))
  end

  def calc
    Calculator.new
  end
end


class Calculator

  class NegativesNotAllowed < StandardError; end

  def add(expression)
    numbers = deserialize_input(expression)
    check_for_negatives(numbers)
    numbers.inject(0, :+)
  end

  private
  def deserialize_input(input) 
    input = InputDeserializer.new(input)
    input.get_numbers
  end

  def check_for_negatives(numbers) 
    negative = numbers.find { |num| num < 0 }
    unless negative.nil?
      raise NegativesNotAllowed.new("negatives are not allowed: #{negative}")
    end
  end

end

class InputDeserializer
  def initialize(value)
    @value = value
  end

  def get_numbers
    change_optional_delimiter_to_comma 
    change_newlines_to_comma
    split_by_comma.map(&:to_i)
  end

  def change_optional_delimiter_to_comma
    if has_optional_delimiter?
      @value.gsub!(optional_delimiter, ",")
    end
  end

  def has_optional_delimiter?
    @value.start_with?("//")
  end

  def optional_delimiter
    between("//", "\n")
  end

  def between(left, right)
    @value[/#{Regexp.escape(left)}(.*?)#{Regexp.escape(right)}/m, 1]
  end

  def change_newlines_to_comma
    @value.gsub!(/\n/, ',')
  end

  def split_by_comma
    @value.split(",")
  end

end
