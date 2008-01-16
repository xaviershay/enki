# Test for facets/comparable/cmp.rb

require 'facets/comparable/cmp.rb'

require 'test/unit'

class TestComparable < Test::Unit::TestCase

  def test_cmp
    assert_equal( -1, 3.cmp(4) )
    assert_equal(  0, 3.cmp(3) )
    assert_equal(  1, 3.cmp(2) )
  end

end

class TestStringCompare < Test::Unit::TestCase

  def test_cmp
    assert_equal( 0, "abc".cmp("abc") )
    assert_equal( -1, "abc".cmp("abcd") )
    assert_equal( 1, "abcd".cmp("abc") )
    assert_equal( -1, "abc".cmp("bcd") )
    assert_equal( 1, "bcd".cmp("abc") )
  end

  def test_succ
    assert_equal( "b", "a".succ )
    assert_equal( "b", "a".succ(1) )
    assert_equal( "c", "a".succ(2) )
    assert_equal( "d", "a".succ(3) )
  end

end

class TestNumericCompare < Test::Unit::TestCase

  def test_distance
    assert_equal( 4, 10.distance(6) )
    assert_equal( 2, 10.distance(8) )
    assert_equal( -2, 7.distance(9) )
  end


  def test_pred
    assert_equal(  3,  4.pred )
    assert_equal( -3, -2.pred )
    assert_equal(  2,  4.pred(2) )
    assert_equal( -4, -2.pred(2) )
    assert_equal(  6,  4.pred(-2) )
    assert_equal(  0, -2.pred(-2) )
  end

  def test_succ
    assert_equal(  5,  4.succ )
    assert_equal( -1, -2.succ )
    assert_equal(  6,  4.succ(2) )
    assert_equal(  0, -2.succ(2) )
    assert_equal(  2,  4.succ(-2) )
    assert_equal( -4, -2.succ(-2) )
  end

end
