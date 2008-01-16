# Test for facets/hash/op

require 'facets/hash/op.rb'

require 'test/unit'

class TestHashOperate < Test::Unit::TestCase

  def test_op_and_hash
    a = { :a => 1, :b => 2 }
    b = { :a => 1 }
    r = { :a => 1 }
    assert_equal( r, a & b )
  end

  def test_op_and_hash_subarray
    a = { :a => [1], :b => [2] }
    b = { :a => [1] }
    r = { :a => [1] }
    assert_equal( r, a & b )
  end

  def test_op_and_array
    a = { :a => 1, :b => 2 }
    b = [ :a ]
    r = { :a => 1 }
    assert_equal( r, a & b )
  end

  def test_shift_update
    a = { :a => 1, :b => 2, :c => 3 }
    b = { :a => 0, :d => 4 }
    e = { :a => 0, :b => 2, :c => 3, :d => 4 }
    assert_equal( e, a << b )
  end

  def test_op_minus_array
    a = { :a => 1, :b => 2, :c => 3 }
    b = [ :a ]
    e = { :b => 2, :c => 3 }
    assert_equal( e, a - b )
  end

  def test_op_minus_hash
    a = { :a => 1, :b => 2, :c => 3 }
    b = { :a => 1, :d => 4 }
    e = { :b => 2, :c => 3 }
    assert_equal( e, a - b )
  end

end
