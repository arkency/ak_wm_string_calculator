require 'test/unit'

class StringCalculatorTest < Test::Unit::TestCase
  def test_empty
    calc = Calculator.new
    assert_equal calc.add(""), 0
  end
end
