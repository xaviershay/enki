# Test for lib/facets/range/combine

require 'facets/range/combine.rb'

require 'test/unit'

class TestRangeCombine < Test::Unit::TestCase

  def test_combine_ranges
    r = Range.combine(0..4, 2..6, 6..10, 13..17, 12..19)
    x = [0..10, 12..19]
    assert_equal(x, r)
  end

  def test_combine_arrays_as_intervals
    r = Range.combine([0, 4], [2, 6], [6, 10], [13, 17], [12, 19])
    x = [[0, 10], [12, 19]]
    assert_equal(x, r)
  end

end
