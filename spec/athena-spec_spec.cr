require "./spec_helper"

# IDK how to test the testing stuff,
# so I'll just use the example and call it good enough.

private class Calculator
  def add(v1, v2)
    v1 + v2
  end

  def substract(v1, v2)
    raise NotImplementedError.new "TODO"
  end
end

struct ExampleSpec < ASPEC::TestCase
  @target : Calculator

  def initialize : Nil
    @target = Calculator.new
  end

  def test_add : Nil
    @target.add(1, 2).should eq 3
  end

  # A pending test.
  def ptest_substract : Nil
    @target.substract(10, 5).should eq 5
  end
end

abstract struct SomeTypeTestCase < ASPEC::TestCase
  protected abstract def get_object : Calculator

  def test_common : Nil
    self.get_object.is_a? Calculator
  end
end

struct CalculatorTest < SomeTypeTestCase
  protected def get_object : Calculator
    Calculator.new
  end

  def test_specific : Nil
    self.get_object.add(1, 1).should eq 2
  end
end

struct DataProviderTest < ASPEC::TestCase
  # Data Providers allow reusing a test's multiple times with different input.
  @[DataProvider("get_values")]
  def test_squares(value : Int32, expected : Int32) : Nil
    (value ** 2).should eq expected
  end

  # Returns a hash where the key represents the name of the test,
  # and the value is a Tuple of data that should be provided to the test.
  def get_values
    {
      "two"   => {2, 4},
      "three" => {3, 9},
    }
  end
end
