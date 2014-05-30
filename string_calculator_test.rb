require 'test/unit'

class StringCalculatorTest < Test::Unit::TestCase
  def test_empty
    assert_equal(0, calc.add(""))
  end

  def test_one
    assert_equal(1, calc.add("1"))
  end

  def test_two
    assert_equal(3, calc.add("1,2"))
  end

  def calc
    Calculator.new
  end
end


class Calculator
  def add(expression)
    expression.split(",").map(&:to_i).inject(0, :+)
  end
end
