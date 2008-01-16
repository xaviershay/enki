# Test for facets/enumerable/probability

require 'facets/enumerable/probability.rb'
require 'test/unit'

class TestEnumerable < Test::Unit::TestCase

  def test_entropy
    assert_equal( 1.0, %w{ a b }.entropy )
  end

  def test_ideal_entropy
    assert_equal( 1.0, %w{ a b }.ideal_entropy )
    assert_equal( 2.0, %w{ a a b b }.ideal_entropy )
  end

  def test_probability
    assert_equal( {'a'=>0.5,'b'=>0.5}, %w{a b}.probability )
    assert_equal( {'tom'=>0.5,'boy'=>0.5}, %w{tom boy}.probability )
  end

  def test_frequency
    assert_equal( {'a'=>1,'b'=>1}, %w{a b}.frequency )
    assert_equal( {'tom'=>1,'boy'=>1}, %w{tom boy}.frequency )
  end

  def test_commonality
    a = [1,2,2,3,3,3]
    r = { 2 => [2,2], 3 => [3,3,3] }
    assert_equal( r, a.commonality )
    a = [1,2,2,3,3,3]
    r = {false=>[1, 2, 2], true=>[3, 3, 3]}
    assert_equal( r, a.commonality { |x| x > 2 } )
  end

  #     def test_collisions
  #       a = [1,2,2,3,3,3]
  #       assert_equal( [2,3], a.collisions )
  #       a = [1,2,2,3,3,3]
  #       r = {false=>[1, 2, 2], true=>[3, 3, 3]}
  #       assert_equal( r, a.collisions { |x| x > 2 } )
  #     end

end
