# Convenience alias to make referencing `Athena::Spec` types easier.
alias ASPEC = Athena::Spec

require "spec"

require "./methods"
require "./test_case"

# A set of common [Spec](https://crystal-lang.org/api/Spec.html) compliant testing utilities/types.
module Athena::Spec
  VERSION = "0.1.0"

  #
  annotation Test; end
  annotation Tags; end
  annotation Focus; end
  annotation Pending; end
  annotation DataProvider; end
end

struct AddSpec < Athena::Spec::TestCase
  @value : Int32

  # Initialize method is executed before every test to reset the state
  def initialize : Nil
    @value = 1
  end

  test "with odd value" do
    @value.should eq 2
  end

  # Any method starting with `test_` is picked up as a test
  def test_a : Nil
    @value.should eq 1
  end

  # Custom name of a method using the annotation
  @[ASPEC::Test]
  def custom_name : Nil
    @value += 1

    @value.should eq 2
  end

  def test_b : Nil
    @value.should eq 1
  end

  def test_with_unequal_value : Nil
    @value.should eq 3
  end
end

AddSpec.run
