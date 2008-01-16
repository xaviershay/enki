# Test lib/facets/curry.rb

require 'facets/curry.rb'
require 'test/unit'

class TestCurry < Test::Unit::TestCase

  def setup
    @p = Proc.new{ |a,b,c| a + b + c }
  end

  def test_first
    n = @p.curry(__,2,3)
    assert_equal( 6, n[1] )
  end

  def test_second
    n = @p.curry(1,__,3)
    assert_equal( 6, n[2] )
  end

  def test_third
    n = @p.curry(1,2,__)
    assert_equal( 6, n[3] )
  end

end
