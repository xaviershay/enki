# Test facets/enumerable/mash.rb

require 'facets/enumerable/mash.rb'
require 'test/unit'

class TestEnumerableMash < Test::Unit::TestCase

  def test_mash_hash_return
    a = { :a => 1, :b => 2, :c => 3 }
    e = { :a => 2, :b => 3, :c => 4 }
    assert_equal( e, a.mash{ |k,v| {k => v+1} } )
  end

  def test_mash_hash_of_array
    a = { :a => [1,2], :b => [2,3], :c => [3,4] }
    e = { :a => 2, :b => 6, :c => 12 }
    assert_equal( e, a.mash{ |k,v| [k, v[0]*v[1] ] } )
  end

  def test_mash_array_of_array
    a = [ [1,2], [2,3], [3,4] ]
    e = { [1,2] => 2, [2,3] => 6, [3,4] => 12 }
    assert_equal( e, a.mash{ |a| [a, a[0]*a[1] ] } )
  end

  def test_mash_squares
    numbers  = (1..3)
    squares  = numbers.mash{ |n| [n, n*n] }
    assert_equal( {1=>1, 2=>4, 3=>9}, squares )
  end

  def test_mash_roots
    numbers  = (1..3)
    sq_roots = numbers.mash{ |n| [n*n, n] }
    assert_equal( {1=>1, 4=>2, 9=>3}, sq_roots )
  end

  def test_mash_inplace!
    a = { :a => 1, :b => 2, :c => 3 }
    e = { :a => 2, :b => 3, :c => 4 }
    a.mash!{ |k,v| { k => v+1 } }
    assert_equal( e, a )
  end

  def test_mash_inplace_again!
    h  = {:a=>1,:b=>2,:c=>3}
    h.mash!{ |k,v| [v, v*v] }
    assert_equal( {1=>1, 2=>4, 3=>9}, h )
  end

end
