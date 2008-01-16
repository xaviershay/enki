# Test facets/dictionary.rb

require 'facets/dictionary.rb'

require 'test/unit'

class TC_Dictionary < Test::Unit::TestCase

  def test_create
    d = Dictionary['z', 1, 'a', 2, 'c', 3]
    assert_equal( ['z','a','c'], d.keys )
  end

  def test_op_store
    d = Dictionary.new
    d['z'] = 1
    d['a'] = 2
    d['c'] = 3
    assert_equal( ['z','a','c'], d.keys )
  end

  def test_push
    d = Dictionary['a', 1, 'c', 2, 'z', 3]
    assert( d.push('end', 15) )
    assert_equal( 15, d['end'] )
    assert( ! d.push('end', 30) )
    assert( d.unshift('begin', 50) )
    assert_equal( 50, d['begin'] )
    assert( ! d.unshift('begin', 60) )
    assert_equal( ["begin", "a", "c", "z", "end"], d.keys )
    assert_equal( ["end", 15], d.pop )
    assert_equal( ["begin", "a", "c", "z"], d.keys )
    assert_equal( ["begin", 50], d.shift )
  end

  def test_insert
    # front
    d = Dictionary['a', 1, 'b', 2, 'c', 3]
    r = Dictionary['d', 4, 'a', 1, 'b', 2, 'c', 3]
    assert_equal( 4, d.insert(0,'d',4) )
    assert_equal( r, d )
    # back
    d = Dictionary['a', 1, 'b', 2, 'c', 3]
    r = Dictionary['a', 1, 'b', 2, 'c', 3, 'd', 4]
    assert_equal( 4, d.insert(-1,'d',4) )
    assert_equal( r, d )
  end

  def test_update
    # with other orderred hash
    d = Dictionary['a', 1, 'b', 2, 'c', 3]
    c = Dictionary['d', 4]
    r = Dictionary['a', 1, 'b', 2, 'c', 3, 'd', 4]
    assert_equal( r, d.update(c) )
    assert_equal( r, d )
    # with other hash
    d = Dictionary['a', 1, 'b', 2, 'c', 3]
    c = { 'd' => 4 }
    r = Dictionary['a', 1, 'b', 2, 'c', 3, 'd', 4]
    assert_equal( r, d.update(c) )
    assert_equal( r, d )
  end

  def test_merge
    # with other orderred hash
    d = Dictionary['a', 1, 'b', 2, 'c', 3]
    c = Dictionary['d', 4]
    r = Dictionary['a', 1, 'b', 2, 'c', 3, 'd', 4]
    assert_equal( r, d.merge(c) )
    # with other hash
    d = Dictionary['a', 1, 'b', 2, 'c', 3]
    c = { 'd' => 4 }
    r = Dictionary['a', 1, 'b', 2, 'c', 3, 'd', 4]
    assert_equal( r, d.merge(c) )
  end

  def test_order_by
    d = Dictionary['a', 3, 'b', 2, 'c', 1]
    d.order_by{ |k,v| v }
    assert_equal( [1,2,3], d.values )
    assert_equal( ['c','b','a'], d.keys )
  end

  def test_op_store
    d = Dictionary[]
    d[:a] = 1
    d[:c] = 3
    assert_equal( [1,3], d.values )
    d[:b,1] = 2
    assert_equal( [1,2,3], d.values )
    assert_equal( [:a,:b,:c], d.keys )
  end

  def test_reverse!
    d = Dictionary['z', 1, 'a', 2, 'c', 3]
    d.reverse!
    assert_equal( ['c','a','z'], d.keys )
  end

  def test_enumerable
    d = Dictionary[]
    d[:a] = "a"
    d[:c] = "b"
    assert_equal( ["A","B"], d.collect{|k,v| v.capitalize} )
  end

  def test_autohash
    d = Dictionary.new{ |hash,key| hash[key] = 0 }
    d[:a] = 0
    d[:b] += 1
    assert_equal([0, 1], d.values)
    assert_equal([:a,:b], d.keys)
  end

  def test_dup_with_array_values
    d = Dictionary.new
    d.dup
    d[:a]=['t',5]
    assert_equal(d, d.dup)
  end
end

