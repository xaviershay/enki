# Test for facets/hash/swap

require 'facets/hash/swap.rb'

require 'test/unit'

class TestHashRekey < Test::Unit::TestCase

  def test_swap!
    h = { :a=>1, :b=>2 }
    assert_equal( { :a=>2, :b=>1 }, h.swap!(:a, :b) )
  end

  def test_swapkeys!
    foo = { :a=>1, :b=>2 }
    assert_equal( { 'a'=>1, :b=>2 }, foo.swapkey!('a', :a) )
    assert_equal( { 'a'=>1, 'b'=>2 }, foo.swapkey!('b', :b) )
    assert_equal( { 'a'=>1, 'b'=>2 }, foo.swapkey!('foo','bar') )
  end

end
