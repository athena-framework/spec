# Convenience alias to make referencing `Athena::Spec` types easier.
alias ASPEC = Athena::Spec

require "./methods"
require "./test_case"

# A set of common [Spec](https://crystal-lang.org/api/Spec.html) compliant testing utilities/types.
module Athena::Spec
  # Runs all `ASPEC::TestCase`s.
  #
  # Is equivalent to manually calling `.run` on each test case.
  def self.run_all : Nil
    {% for unit_test in ASPEC::TestCase.all_subclasses.reject &.abstract? %}
      {{unit_test.id}}.run
    {% end %}
  end
end
