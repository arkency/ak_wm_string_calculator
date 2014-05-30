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
    if expression.start_with?("//")
      expression.gsub!(optional_delimeter(expression), ",")
    end
    expression.gsub(/\n/, ',').split(",").map(&:to_i).inject(0, :+)
  end

  def optional_delimeter(expression)
    string_between(expression, "//", "\n")
  end

  def string_between(expression, left, right)
    expression[/#{Regexp.escape(left)}(.*?)#{Regexp.escape(right)}/m, 1]
  end
end
