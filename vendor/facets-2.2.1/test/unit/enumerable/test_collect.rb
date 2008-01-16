# Test for facets/enumerable/collect

require 'facets/enumerable/collect.rb'
require 'test/unit'

class TestEnumerable < Test::Unit::TestCase

  def test_filter_collect
    e = [3,4]
    a = [1,2,3,4].filter_collect { |n|
      throw(:skip) if n < 3
      n
    }
    assert_equal( e, a )
  end

  def test_compact_collect
    a = [1,2,nil,4].compact_collect { |e| e }
    assert_equal( [1,2,4], a )
  end

  def test_filter_collect
    e = [3,4]
    a = [1,2,3,4].filter_collect { |n|
      throw(:skip) if n < 3
      n
    }
    assert_equal( e, a )
  end

  def test_compact_collect
    a = [1,2,nil,4].compact_collect { |e| e }
    assert_equal( [1,2,4], a )
  end

  def test_collect_with_index
    a = [1,2,3].collect_with_index{ |e,i| e*i }
    assert_equal( [0,2,6], a )
  end

  def test_map_send
    r = [1,2,3].map_send(:+, 1)
    assert_equal(r, [2,3,4])
  end

  def test_map_send_with_block
    r = [1,2,3].map_send(:+,1){ |x| x + 1 }
    assert_equal(r, [3,4,5])
  end

  def test_injecting
    r = [1,2,3,4,5].injecting([]){ |a,i| a << i % 2 }
    e = [1,0,1,0,1]
    assert_equal(e, r)
  end

  def test_injecting_equal
    r = [].injecting([]){ |a,i| a << i % 2 }
    e = []
    assert_equal(e, r)
  end

end
