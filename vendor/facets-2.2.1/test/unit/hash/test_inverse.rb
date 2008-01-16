# Test for lib/facets/hash/inverse

require 'facets/hash/inverse.rb'

require 'test/unit'

class TestHashInverse < Test::Unit::TestCase

  def test_inverse
    h1 = { :a=>1, :b=>2, :c=>2 }
    h2 = h1.inverse
    assert_equal( :a, h2[1] )
    assert( h2[2].include?(:b) )
    assert( h2[2].include?(:c) )
  end

end
