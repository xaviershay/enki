# Test for facets/enumerable/combination.rb

require 'facets/enumerable/combination.rb'
require 'test/unit'

class TestEnumerableCombination < Test::Unit::TestCase

  def test_combinations
    a = [1,2]
    b = [3,4]
    z = Enumerable.combinations(a,b)
    r = [[1,3],[1,4],[2,3],[2,4]]
    assert_equal( r, z )
  end

  def test_combinations_of_three
    a = %w|a b|
    b = %w|a x|
    c = %w|x y|
    z = Enumerable.combinations(a, b, c)
    r = [ ["a", "a", "x"],
          ["a", "a", "y"],
          ["a", "x", "x"],
          ["a", "x", "y"],
          ["b", "a", "x"],
          ["b", "a", "y"],
          ["b", "x", "x"],
          ["b", "x", "y"] ]
    assert_equal( r, z )
  end

  def test_each_combination
    r = []
    a = [1,2,3,4]
    a.each_combination(2){ |a,b| r << [a,b] }
    assert_equal( [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]], r )
  end

#   DEPRECATED
#   def test_each_unique_pair
#     r = []
#     a = [1,2,3,4]
#     a.each_unique_pair{ |a,b| r << [a,b] }
#     assert_equal( [[1,2],[1,3],[1,4],[2,3],[2,4],[3,4]], r )
#   end

end

