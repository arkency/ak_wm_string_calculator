require 'test/unit'

class StringCalculatorTest < Test::Unit::TestCase
  def test_adding
    assert_add(0, "")
    assert_add(1, "1")
    assert_add(3, "1,2")
    assert_add(10, "1,2,3,4")
    assert_add(10, "1\n2\n3\n4")
    assert_add(5, "//*\n4*1")
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

  def add(expression)
    input = Input.new(expression)
    input.change_optional_delimiter_to_comma if input.has_optional_delimiter?
    input.change_newlines_to_comma
    input.split_by_comma.map(&:to_i).inject(0, :+)
  end

end

class Input
  def initialize(value)
    @value = value
  end

  def has_optional_delimiter?
    @value.start_with?("//")
  end

  def change_optional_delimiter_to_comma
    @value.gsub!(optional_delimiter, ",")
  end

  def change_newlines_to_comma
    @value.gsub!(/\n/, ',')
  end

  def split_by_comma
    @value.split(",")
  end

  def optional_delimiter
    between("//", "\n")
  end

  def between(left, right)
    @value[/#{Regexp.escape(left)}(.*?)#{Regexp.escape(right)}/m, 1]
  end
end
