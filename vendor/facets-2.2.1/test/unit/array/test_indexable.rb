#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |
#   |_|\___||___/\__|
#

require 'facets/array/indexable.rb'

require 'test/unit'

class TestArray < Test::Unit::TestCase

  #def test_op_mod
  #  a = [:A,:B,:C]
  #  assert_equal( a[1], a/1 )
  #  assert_equal( :B, a/1 )
  #end
  #
  #def test_op_div
  #  a = [:A,:B,:C]
  #  assert_equal( a[1], a/1 )
  #  assert_equal( :B, a/1 )
  #end

  def test_head
    a = [1,2,3,4,5]
    assert_equal( [1], a.head )
  end

  def test_tail
    a = [1,2,3,4,5]
    assert_equal( [2,3,4,5], a.tail )
  end

  def test_foot
    a = [1,2,3,4,5]
    assert_equal( [5], a.foot )
  end

  def test_body
    a = [1,2,3,4,5]
    assert_equal( [1,2,3,4], a.body )
  end

  def test_mid
    a = [1,2,3,4,5]
    b = [1,2,3,4,5,6]
    assert_equal( 3, a.mid )
    assert_equal( 4, b.mid )
    assert_equal( 4, a.mid(1) )
    assert_equal( 5, b.mid(1) )
    assert_equal( 6, b.mid(2) )
    assert_equal( 3, b.mid(-1) )
  end

  def test_middle
    a = [1,2,3,4,5]
    b = [1,2,3,4,5,6]
    assert_equal( 3, a.middle )
    assert_equal( [3,4], b.middle )
  end

  #def test_op_fetch
  #  a = ['a','b','c','d','e','f']
  #  assert_equal( ['b','f'], a[[1,-1]] )
  #end
  #
  #def test_op_store
  #  a = ['a','o','z']
  #  a[[0,2]] = ['A','Z']
  #  assert_equal( ['A','o','Z'], a )
  #  a[[0,-1]] = ['W','Y']
  #  assert_equal( ['W','o','Y'], a )
  #end

  def test_thru
    assert_equal( [2,3,4], [0,1,2,3,4,5].thru(2,4) )
    assert_equal( [0,1], [0,1,2,3,4,5].thru(0,1) )
  end

  def test_first_eq
    a = [1,2]
    a.first = 0
    assert_equal( [0,2], a )
  end

  def test_last_eq
    a = [1,2]
    a.last = 3
    assert_equal( [1,3], a )
  end

  def test_ends
    assert_equal( [1,2,3,4,5].ends, 4 )
  end

  def test_pos
    a = [1,2,3,4,5]
    assert_equal( 0, a.pos(1) )
    assert_equal( 4, a.pos(-1) )
  end

  def test_range
    a = [1,2,3,4,5]
    b = [1,2,3,4,5,6]
    assert_equal( (0..4), a.range )
    assert_equal( (0..5), b.range )
    assert_equal( (1..3), a.range(2,4) )
    assert_equal( (1..2), b.range(2,3) )
    assert_equal( (3..1), b.range(4,2) )
  end

  def test_first!
    a = [1,2,3]
    assert_equal( 1, a.first! )
    assert_equal( [2,3], a )
  end

  def test_last!
    a = [1,2,3]
    assert_equal( 3, a.last! )
    assert_equal( [1,2], a )
  end

end
