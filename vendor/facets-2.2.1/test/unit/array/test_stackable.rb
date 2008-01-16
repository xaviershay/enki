# Test facets/array/stackable.rb

require 'facets/array/stackable.rb'

require 'test/unit'

class TestArray < Test::Unit::TestCase

  def test_poke
    a = [2,3]
    assert_equal( [1,2,3], a.poke(1) )
    assert_equal( [4,1,2,3], a.poke(4) )
  end

  def test_pull
    a = [1,2,3]
    assert_equal( 1, a.pull )
    assert_equal( [2,3], a )
  end

end

