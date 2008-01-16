# Test for facets/enumerable/cartesian.rb

require 'facets/enumerable/cartesian.rb'

require 'test/unit'

class TestEnumerableClass < Test::Unit::TestCase

  def test_cart_01
    i = [[1,2], [3,4]]
    o = [[1, 3], [1, 4], [2, 3], [2, 4]]
    assert_equal( o, Enumerable.cart(*i) )
  end

  def test_cart_02
    i = [[1,2], [4], ["apple", "banana"]]
    o = [[1, 4, "apple"], [1, 4, "banana"], [2, 4, "apple"], [2, 4, "banana"]]
    assert_equal( o, Enumerable.cart(*i) )
  end

  def test_cart_03
    a = [1,2,3].cart([4,5,6])
    assert_equal( [[1, 4],[1, 5],[1, 6],[2, 4],[2, 5],[2, 6],[3, 4],[3, 5],[3, 6]], a )
  end

  def test_cart_04
    a = []
    [1,2,3].cart([4,5,6]) {|elem| a << elem }
    assert_equal( [[1, 4],[1, 5],[1, 6],[2, 4],[2, 5],[2, 6],[3, 4],[3, 5],[3, 6]], a )
  end

  def test_op_pow
    a = [1,2,3] ** [4,5,6]
    assert_equal( [[1, 4],[1, 5],[1, 6],[2, 4],[2, 5],[2, 6],[3, 4],[3, 5],[3, 6]], a )
  end

end


