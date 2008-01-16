# Test for lib/facets/proc/compose

require 'facets/proc/compose.rb'

require 'test/unit'

class TestProc < Test::Unit::TestCase

  def test_compose_op
    a = lambda { |x| x + 4 }
    b = lambda { |y| y / 2 }
    assert_equal( 6, (a * b).call(4) )
    assert_equal( 4, (b * a).call(4) )
  end

  def test_times_collect_op
    a = lambda { |x| x + 4 }
    assert_equal( [4,5,6], a * 3 )
  end

  def test_compose
    a = lambda { |x| x + 4 }
    b = lambda { |y| y / 2 }
    assert_equal( 6, (a.compose(b)).call(4) )
    assert_equal( 4, (b.compose(a)).call(4) )
  end

end
