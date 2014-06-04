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
    assert_add(2, "1001,2")
    assert_add(6, "“//[***]\n1***2***3***2000” ")
    assert_not_allowed('negatives are not allowed: -1', "1,-1")
    assert_not_allowed('negatives are not allowed: -1, -5, -7', "1,-1,2,3,4,-5,-7")
  end

  private
  def assert_add(expected, expression)
    assert_equal(expected, calc.add(expression))
  end

  def assert_not_allowed(message, expression)
    assert_raise_with_message Calculator::NegativesNotAllowed, message do
      calc.add(expression)
    end
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
    numbers = delete_greater_than_1000.numbers
    numbers.inject(0, :+)
  end

  private
  def deserialize_input(input) 
    input = InputDeserializer.new(input)
    input.get_numbers
  end

  def check_for_negatives(numbers) 
    negatives = numbers.select { |num| num < 0 }
    raise_negatives_not_allowed(negatives) unless negatives.empty?
  end

  def delete_greater_than_1000(numbers)
    numbers.delete_if { |x| x > 1000 }
  end

  def raise_negatives_not_allowed(negatives)
    raise NegativesNotAllowed.new(negatives_message(negatives))
  end

  def negatives_message(negatives)
    "negatives are not allowed: #{negatives.join(", ")}"
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
