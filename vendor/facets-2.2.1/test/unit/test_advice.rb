# Test for facets/advice.rb

require 'test/unit'
require 'facets/advice'

class TestAdvice < Test::Unit::TestCase

  class X
    extend Advisable

    attr_reader :out

    def initialize
      @out = []
    end

    before :x do
      @out << "BEFORE X#x"
    end

    after :x do
      @out << "AFTER X#x"
    end

    def x
      @out << "X#x"
      "x"
    end
  end

  class Y < X
    before :x do
      @out << "BEFORE Y#x"
    end

    after :x do
      @out << "AFTER Y#x"
    end

    around :x do |target|
      "{" + target.call + "}"
    end

    def x
      @out << "Y#x"
      super
    end
  end

  # tests

  def setup
    @x = X.new
    @y = Y.new
  end

  def test_x
    r = @x.x
    o = @x.out
    assert_equal("x", r)
    assert_equal(["BEFORE X#x", "X#x", "AFTER X#x"], o)
  end

  def test_y
    r = @y.x
    o = @y.out
    assert_equal("{x}", r)
    assert_equal(["BEFORE Y#x", "BEFORE X#x", "Y#x", "X#x", "AFTER X#x", "AFTER Y#x"], o)
  end

end
