# Test for facets/comparable/bound.rb

require 'facets/comparable/bound.rb'

require 'test/unit'

class TestComparable < Test::Unit::TestCase

  def test_at_most
    assert_equal( 3, 3.at_most(4) )
    assert_equal( 4, 4.at_most(4) )
    assert_equal( 4, 5.at_most(4) )
  end

  def test_at_least
    assert_equal( 4, 3.at_least(4) )
    assert_equal( 4, 4.at_least(4) )
    assert_equal( 5, 5.at_least(4) )
  end

  def test_clip
    assert_equal( 4, 3.clip(4) )
    assert_equal( 4, 4.clip(4) )
    assert_equal( 5, 5.clip(4) )
    assert_equal( 4, 4.clip(3,5) )
    assert_equal( 3, 3.clip(3,5) )
    assert_equal( 5, 5.clip(3,5) )
    assert_equal( 3, 2.clip(3,5) )
    assert_equal( 5, 6.clip(3,5) )
    assert_equal( 'd', 'd'.clip('c','e') )
    assert_equal( 'c', 'c'.clip('c','e') )
    assert_equal( 'e', 'e'.clip('c','e') )
    assert_equal( 'c', 'b'.clip('c','e') )
    assert_equal( 'e', 'f'.clip('c','e') )
  end

  def test_cap
    assert_equal( 3, 3.cap(4) )
    assert_equal( 4, 4.cap(4) )
    assert_equal( 4, 5.cap(4) )
  end

end
