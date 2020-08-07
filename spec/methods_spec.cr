require "./spec_helper"

describe ASPEC::Methods do
  describe "#assert_error" do
    it do
      assert_error "abstract_class.cr", "can't instantiate abstract class Foo"
    end
  end

  describe "#run_executable" do
    it "without input" do
      run_executable "ls", ["./.github"] do |output, error, status|
        output.should eq %(workflows\n)
        error.should be_empty
        status.success?.should be_true
      end
    end

    it "with input" do
      input = IO::Memory.new %({"id":1})

      run_executable "jq", input, [".", "-c"] do |output, error, status|
        output.should eq %({"id":1}\n)
        error.should be_empty
        status.success?.should be_true
      end
    end

    it "with error output" do
      input = IO::Memory.new %({"id"1})

      run_executable "jq", input, [".", "-c"] do |output, error, status|
        output.should be_empty
        error.should eq %(parse error: Expected separator between values at line 1, column 7\n)
        status.success?.should be_false
      end
    end
  end
end
