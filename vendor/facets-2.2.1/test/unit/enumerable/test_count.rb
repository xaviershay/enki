# Test for facets/enumerable/count.rb

require 'facets/enumerable/count.rb'

require 'test/unit'

class TestEnumerableCount < Test::Unit::TestCase

  def test_occur
    arr = [:a,:b,:a]
    assert_equal( [:b], arr.occur(1) )
    assert_equal( [:a], arr.occur(2) )
    assert_equal( [:b], arr.occur(1..1) )
    assert_equal( [:a], arr.occur{ |n| n % 2 == 0 } )
  end

  def test_count_01
    e = [ 'a', '1', 'a' ]
    assert_equal( 1, e.count('1') )
    assert_equal( 2, e.count('a') )
  end

  def test_count_02
    e = [ ['a',2], ['a',2], ['a',2], ['b',1] ]
    assert_equal( 3, e.count(['a',2]) )
  end

  def test_count_03
    e = { 'a' => 2, 'a' => 2, 'b' => 1 }
    assert_equal( 1, e.count('a',2) )
  end

  def test_uniq_by
    a = [-5, -4, -3, -2, -1, 0]
    r = (-5..5).to_a.uniq_by{|i| i*i }
    assert_equal( a, r )
  end

  def test_one?
    a = [nil, true]
    assert( a.one? )
    a = [true, false]
    assert( a.one? )
    a = [true, true]
    assert( ! a.one? )
    a = [true, 1]
    assert( ! a.one? )
    a = [1, 1]
    assert( ! a.one? )
  end

  def test_none?
    a = [nil, nil]
    assert( a.none? )
    a = [false, false]
    assert( a.none? )
    a = [true, false]
    assert( ! a.none? )
    a = [nil, 1]
    assert( ! a.none? )
  end

end
