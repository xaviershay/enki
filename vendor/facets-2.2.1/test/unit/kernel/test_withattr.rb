# Test for facets/kernel/withattr

require 'facets/kernel/withattr.rb'

require 'test/unit'

class TCKernel < Test::Unit::TestCase
  # fixture for #with_reader, #with_writer and #with_accessor
  class TestWith
    def initialize
      with_reader :foo => "FOO"
      with_writer :bar => "BAR"
      with_accessor :baz => "BAZ"
    end
    def get_bar
      @bar
    end
  end

  def test_with_reader
    assert_nothing_raised { @t = TestWith.new }
    assert_equal("FOO", @t.foo)
  end

  def test_with_writer
    assert_nothing_raised { @t = TestWith.new }
    assert_equal("BAR", @t.get_bar)
    @t.bar = "BAR2"
    assert_equal("BAR2", @t.get_bar)
  end

  def test_with_accessor
    assert_nothing_raised { @t = TestWith.new }
    assert_equal("BAZ", @t.baz)
    @t.baz = "BAZ2"
    assert_equal("BAZ2", @t.baz)
  end
end
