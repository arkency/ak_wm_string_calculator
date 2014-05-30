require 'test/unit'

class StringCalculatorTest < Test::Unit::TestCase
  def test_empty
    assert_add(0, "")
  end

  def test_one
    assert_add(1, "1")
  end

  def test_two
    assert_add(3, "1,2")
  end

  def test_multiple
    assert_add(10, "1,2,3,4")
  end


  def assert_add(expected, expression)
    assert_equal(expected, calc.add(expression))
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
