# Test for lib/facets/string/range.rb

require 'facets/string/range.rb'

require 'test/unit'

class TestStringRange < Test::Unit::TestCase

  def test_range
    assert_equal( (1..3), "a123a567a9".range(/123/) )
    assert_equal( (0..0), "a123a567a9".range(/a/) )
  end

  def test_range_all
    assert_equal( [ (1..3), (5..7) ], "a123a123a9".range_all(/123/) )
    assert_equal( [ (0..0), (4..4), (8..8) ], "a123a567a9".range_all(/a/) )
  end

  def test_range_of_line
    a = "0123\n456\n78"
    ltcm = a.range_of_line
    assert_equal( [0..4, 5..8, 9..10], ltcm )
  end

end
