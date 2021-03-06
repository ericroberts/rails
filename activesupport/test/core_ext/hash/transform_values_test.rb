require 'abstract_unit'
require 'active_support/core_ext/hash/indifferent_access'
require 'active_support/core_ext/hash/transform_values'

class TransformValuesTest < ActiveSupport::TestCase
  test "transform_values returns a new hash with the values computed from the block" do
    original = { a: 'a', b: 'b' }
    mapped = original.transform_values { |v| v + '!' }

    assert_equal({ a: 'a', b: 'b' }, original)
    assert_equal({ a: 'a!', b: 'b!' }, mapped)
  end

  test "transform_values! modifies the values of the original" do
    original = { a: 'a', b: 'b' }
    mapped = original.transform_values! { |v| v + '!' }

    assert_equal({ a: 'a!', b: 'b!' }, original)
    assert_same original, mapped
  end

  test "indifferent access is still indifferent after mapping values" do
    original = { a: 'a', b: 'b' }.with_indifferent_access
    mapped = original.transform_values { |v| v + '!' }

    assert_equal 'a!', mapped[:a]
    assert_equal 'a!', mapped['a']
  end

  # This is to be consistent with the behavior of Ruby's built in methods
  # (e.g. #select, #reject) as of 2.2
  test "default values do not persist during mapping" do
    original = Hash.new('foo')
    original[:a] = 'a'
    mapped = original.transform_values { |v| v + '!' }

    assert_equal 'a!', mapped[:a]
    assert_nil mapped[:b]
  end

  test "default procs do not persist after mapping" do
    original = Hash.new { 'foo' }
    original[:a] = 'a'
    mapped = original.transform_values { |v| v + '!' }

    assert_equal 'a!', mapped[:a]
    assert_nil mapped[:b]
  end
end
