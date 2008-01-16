# Test facets/overload.rb

require 'facets/overload.rb'

require 'test/unit'

class TCOverload < Test::Unit::TestCase

  class X

    def x
      "hello"
    end

    overload :x, Integer do |i|
      i
    end

    overload :x, String, String do |s1, s2|
      [s1, s2]
    end

  end

  def setup
    @x = X.new
  end

  def test_x
    assert_equal( "hello", @x.x )
  end

  def test_i
    assert_equal( 1, @x.x(1) )
  end

  def test_s
    assert_equal( ["a","b"], @x.x("a","b") )
  end

end



