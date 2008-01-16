# Test for facets/enumerable/split

require 'facets/enumerable/split.rb'
require 'test/unit'

class TestEnumerable < Test::Unit::TestCase

  def test_group_by_for_array
    a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    r = {0=>[0, 2, 4, 6, 8], 1=>[1, 3, 5, 7, 9]}
    assert_equal(r, a.group_by{|e| e%2}.each{|k, v| v.sort!})

    h = {0=>0, 1=>1, 2=>2, 3=>3, 4=>4, 5=>5, 6=>6, 7=>7, 8=>8, 9=>9}
    r = {0=>[[0, 0], [2, 2], [4, 4], [6, 6], [8, 8]], 1=>[[1, 1], [3, 3], [5, 5], [7, 7], [9, 9]]}
    assert_equal(r, h.group_by{|k, v| v%2}.each{|k, v| v.sort!})

    x = (1..5).group_by{ |n| n % 3 }
    o = { 0 => [3], 1 => [1, 4], 2 => [2,5] }
    assert_equal( o, x )

    x = ["I had", 1, "dollar and", 50, "cents"].group_by{ |e| e.class }
    o = { String => ["I had","dollar and","cents"], Fixnum => [1,50] }
    assert_equal( o, x )
  end

  def test_cluster_by
    a = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    r = [[0, 2, 4, 6, 8], [1, 3, 5, 7, 9]]
    assert_equal(r, a.cluster_by{|e| e%2}.each{|a| a.sort!})
    h = {0=>0, 1=>1, 2=>2, 3=>3, 4=>4, 5=>5, 6=>6, 7=>7, 8=>8, 9=>9}
    r = [[[0, 0], [2, 2], [4, 4], [6, 6], [8, 8]], [[1, 1], [3, 3], [5, 5], [7, 7], [9, 9]]]
    assert_equal(r, h.cluster_by{|k, v| v%2}.each{|a| a.sort!})
  end

  def test_cluster_by_empty
    r = [].cluster_by{ |a| a }
    assert_equal([], r)
  end

  #     def test_op_mod
  #       a = [:A,:B,:C]
  #       assert_equal( a[1], a/1 )
  #       assert_equal( :B, a/1 )
  #     end
  #
  #     def test_op_div
  #       a = [:A,:B,:C]
  #       assert_equal( a[1], a/1 )
  #       assert_equal( :B, a/1 )
  #     end

end
