require 'test/unit'

class StringCalculatorTest < Test::Unit::TestCase
  def test_empty
    assert_equal calc.add(""), 0
  end

  def test_one
    assert_equal calc.add("1"), 1
  end

  def test_two
    assert_equal calc.add("1,2"), 3
  end

  def calc
    Calculator.new
  end
end
