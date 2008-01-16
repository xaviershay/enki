# Test lib/facets/enumerablepass.rb

require 'facets/enumerablepass.rb'
require 'test/unit'

# fixture

class PlusArray
  include EnumerablePass
  def initialize(arr)
    @arr = arr
  end
  def each(n=0)
    @arr.each{ |e| yield(e+n) }
  end
end

class TC_Enumerable < Test::Unit::TestCase

  def test_collect
    t = PlusArray.new([1,2,3])
    assert_equal( [5,6,7], t.collect(4){ |e| e } )
  end

  #def test_each_slice
  #  t = PlusArray.new([1,2,3,4])
  #  a = []
  #  t.each_slice(2,4){ |e,f| a << [e,f] }
  #  assert_equal( [[5,6],[7,8]], a )
  #end

  #def test_find
  #  t = PlusArray.new([1,2,3,4])
  #  f = t.find(2, :ifnone=>lambda{:NOPE}) { |a| a == 10 }
  #  assert_equal(:NOPE, f)
  #end

  def test_grep
    # TODO
  end

  def test_to_a
    t = PlusArray.new([1,2,3])
    assert_equal( [5,6,7], t.to_a(4) )
  end

  def test_min
    t = PlusArray.new([1,2,3])
    assert_equal( 5, t.min(4) )
  end

  def test_max
    t = PlusArray.new([1,2,3])
    assert_equal( 7, t.max(4) )
  end

  def test_include?
    t = PlusArray.new([1,2,3])
    assert( t.include?(7,4) )
  end

  def test_select
    t = PlusArray.new([1,2,3])
    assert_equal( [6], t.select(4){ |x| x == 6 } )
  end

  def test_reject
    t = PlusArray.new([1,2,3])
    assert_equal( [5,7], t.reject(4){ |x| x == 6 } )
  end

end
