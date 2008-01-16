# Test facets/range/overlap

require 'facets/range/overlap.rb'

require 'test/unit'

class TestRangeOverlap < Test::Unit::TestCase

  def test_umbrella_aligned
    assert_equal( [0,0], (3..6).umbrella(3..6) )
    assert_equal( [0,0], (3...6).umbrella(3...6) )
  end

  def test_umbrella_partial_aligned
    assert_equal( [1,0], (3..6).umbrella(2..6) )
    assert_equal( [0,1], (3..6).umbrella(3..7) )
    assert_equal( [-1,0], (3..6).umbrella(4..6) )
    assert_equal( [0,-1], (3..6).umbrella(3..5) )
  end

  def test_umbrella_offset
    assert_equal( [1,1], (3..6).umbrella(2..7) )
    assert_equal( [-1,1], (3..6).umbrella(4..7) )
    assert_equal( [1,-1], (3..6).umbrella(2..5) )
    assert_equal( [-1,-1], (3..6).umbrella(4..5) )
  end

  def test_umbrella_offset_by_exclusion
    assert_equal( [0,1], (10...20).umbrella(10..20) )
  end

  def test_within?
    assert( (4..5).within?(3..6) )
    assert( (3..6).within?(3..6) )
    assert(! (2..5).within?(3..6) )
    assert(! (5..7).within?(3..6) )
  end

end
