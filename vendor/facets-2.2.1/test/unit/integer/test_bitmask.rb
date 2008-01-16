# Test for facets/integer/bitmask

require 'facets/integer/bitmask.rb'

require 'test/unit'

class TestIntegerBitmask < Test::Unit::TestCase

  def test_bit
    assert_equal( 1, 0.bit(0) )
    assert_equal( 2, 0.bit(1) )
    assert_equal( 4, 0.bit(2) )
    assert_equal( 8, 0.bit(3) )
  end

  def test_negate_bit
    assert_equal( 0, 1.bit(~0) )
    assert_equal( 0, 2.bit(~1) )
    assert_equal( 0, 4.bit(~2) )
    assert_equal( 0, 8.bit(~3) )
  end

  def test_clear_bit
    assert_equal( 0, 1.clear_bit(0) )
    assert_equal( 0, 2.clear_bit(1) )
    assert_equal( 0, 4.clear_bit(2) )
    assert_equal( 0, 8.clear_bit(3) )
  end

  def test_bit?
    a = 8
    assert(! a.bit?(0))
    assert(! a.bit?(1))
    assert(! a.bit?(2))
    assert(a.bit?(3))
    assert(! a.bit?(4))
    assert(! a.bit?(5))
  end

  def test_bitmask
    a =  1
    m = Bit(4)
    a = a.bitmask(m)
    assert_equal( 17, a )
    assert( a.bitmask?(m) )
  end

  def test_Bit
    n = Bit(4)
    assert_equal(16, n)
  end

end
