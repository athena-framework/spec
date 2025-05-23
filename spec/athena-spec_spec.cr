require "./spec_helper"

# IDK how to test the testing stuff,
# so I'll just use the example and call it good enough.

private class Calculator
  def add(v1, v2)
    v1 + v2
  end

  def subtract(v1, v2)
    raise NotImplementedError.new "TODO"
  end
end

@[ASPEC::TestCase::Skip]
struct SkipSpec < ASPEC::TestCase
  def test_skipped
    fail "Test should have been skipped"
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
  def ptest_subtract : Nil
    @target.subtract(10, 5).should eq 5
  end

  test "with macro helper" do
    @target.add(1, 2).should eq 3
  end

  test "GET /api/:slug" do
    @target.add(1, 2).should eq 3
  end

  test "123_foo bar" do
    @target.add(1, 2).should eq 3
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
  @[DataProvider("get_values_hash")]
  @[DataProvider("get_values_named_tuple")]
  def test_squares(value : Int32, expected : Int32) : Nil
    (value ** 2).should eq expected
  end

  def get_values_hash : Hash
    {
      "two"   => {2, 4},
      "three" => {3, 9},
    }
  end

  def get_values_named_tuple : NamedTuple
    {
      four: {4, 16},
      five: {5, 25},
    }
  end

  @[DataProvider("get_values_array")]
  @[DataProvider("get_values_tuple")]
  def test_cubes(value : Int32, expected : Int32) : Nil
    (value ** 3).should eq expected
  end

  def get_values_array : Array
    [
      {2, 8},
      {3, 27},
    ]
  end

  def get_values_tuple : Tuple
    {
      {4, 64},
      {5, 125},
    }
  end
end

abstract struct AbstractParent < ASPEC::TestCase
  @[DataProvider("get_values")]
  def test_cubes(value : Int32, expected : Int32) : Nil
    value.should eq expected
  end

  def get_values : Tuple
    {
      {1, 1},
      {2, 2},
    }
  end
end

struct Child < AbstractParent; end

struct TestWithTest < ASPEC::TestCase
  @[TestWith(
    {4, 64},
    {5, 125},
  )]
  def test_cubes(value : Int32, expected : Int32) : Nil
    (value ** 3).should eq expected
  end

  @[TestWith(
    two: {2, 4},
    three: {3, 9},
    "with spaces": {4, 16},
  )]
  def test_squares(value : Int32, expected : Int32) : Nil
    (value ** 2).should eq expected
  end
end

struct BeforeAllTest < ASPEC::TestCase
  @count : Int32 = 0

  def initialize
    @count.should eq 1
  end

  def before_all : Nil
    @count += 1
  end

  def test_before_all_runs_before_initialize : Nil
    # no-op
  end

  def test_before_all_runs_before_initialize2 : Nil
    # no-op
  end
end

abstract struct GenericTestCase(T) < ASPEC::TestCase
end

struct GenericIntTest < GenericTestCase(Int32)
  @@count : Int32 = 0

  def test_runs_once
    1.should eq 1
    @@count += 1
  end

  def after_all : Nil
    it "runs generic string inheritance test cases only once" { @@count.should eq 1 }
  end
end

struct GenericStringTest < GenericTestCase(String)
  @@count : Int32 = 0

  def test_runs_once
    1.should eq 1
    @@count += 1
  end

  def after_all : Nil
    it "runs generic int inheritance test cases only once" { @@count.should eq 1 }
  end
end
