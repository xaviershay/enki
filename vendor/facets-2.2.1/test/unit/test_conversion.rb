# Test facets/conversions.rb

require 'facets/conversion.rb'
require 'test/unit'


class TestArrayConversion < Test::Unit::TestCase

  def test_to_h
    a = [[1,2],[3,4],[5,6]]
    assert_equal( { 1=>2, 3=>4, 5=>6 }, a.to_h )
  end

  def test_to_h_arrayed
    a = [[:a,1,2],[:b,3,4],[:c,5,6]]
    assert_equal( { :a=>[1,2], :b=>[3,4], :c=>[5,6] }, a.to_h(true) )
  end

  def test_to_hash
    a = [:a,:b,:c]
    assert_equal( { 0=>:a, 1=>:b, 2=>:c }, a.to_hash )
  end

end


class TestClassConversion < Test::Unit::TestCase

  Person = Struct.new(:name)

  def test_to_proc
    people = ["joe"].map(&Person)
    assert_equal("joe", people[0].name)
  end

end


class TestEnumerableConversion < Test::Unit::TestCase

  def test_to_hash
    a = [:a,:b,:c]
    assert_equal( { 0=>:a, 1=>:b, 2=>:c }, a.to_hash )
  end

  def test_to_h
    a = [[1,:a],[2,:b],[3,:c]]
    assert_equal( { 1=>:a, 2=>:b, 3=>:c }, a.to_h )
  end

end


class TestHashConversion < Test::Unit::TestCase

  def test_to_h
    a = { :a => 1, :b => 2, :c => 3 }
    assert_equal( a, a.to_h )
  end

end


class TestNilClassConversion < Test::Unit::TestCase

  def test_to_f
    assert_equal( 0, nil.to_f )
  end

  def test_to_h
    assert_equal( {}, nil.to_h )
  end

end


class TestRangeConversion < Test::Unit::TestCase

  def test_to_r
    a = (0..10)
    assert_equal( a, a.to_r )
  end

  def test_to_range
    a = (0..10)
    assert_equal( a, a.to_range )
  end

end


class TestRegexpConversion < Test::Unit::TestCase

  def test_to_re
    r = /0..10/
    assert_equal( r, r.to_re )
  end

  def test_to_regexp
    r = /0..10/
    assert_equal( r, r.to_regexp )
  end

end


class TestStringConversion < Test::Unit::TestCase

  TestConst = 4

  def test_to_const
    assert_equal( 4, "TestStringConversion::TestConst".to_const )
  end

  def test_to_date
    s = "2005-10-31"
    d = s.to_date
    assert_equal( 31, d.day )
    assert_equal( 10, d.month )
    assert_equal( 2005, d.year )
  end

  def test_to_time
    s = "2:31:15 PM"
    t = s.to_time
    assert_equal( 14, t.hour )
    assert_equal( 31, t.min )
    assert_equal( 15, t.sec )
  end

  def test_to_re
    assert_equal( /abc/, "abc".to_re )
    assert_equal( /a\+bc/, "a+bc".to_re )
    assert_equal( /a+bc/, "a+bc".to_re(false) )
  end

  def test_to_proc
    assert_nothing_raised { @add = '|x,y| x + y'.to_proc }
    assert_equal(4, @add.call(2,2))
    @t = 3
    @multi = '|y| @t * y'.to_proc(self)
    assert_equal(6, @multi.call(2))
    x = 4
    @div = '|y| x / y'.to_proc(binding)
    assert_equal(2, @div.call(2))
  end

  #def test_to_a
  #  arr = 'abc'
  #  assert_equal( ['a','b','c'], arr.to_a )
  #end

end


class TestSymbolConversion < Test::Unit::TestCase

  TESTCONST = 1

  def test_to_const
    assert_equal( 1, :"TestSymbolConversion::TESTCONST".to_const )
  end

  def test_proc_01
    assert_instance_of(Proc, up = :upcase.to_proc )
    assert_equal( "HELLO", up.call("hello") )
  end

  def test_proc_02
    q = [[1,2,3], [4,5,6], [7,8,9]].map(&:reverse)
    a = [[3, 2, 1], [6, 5, 4], [9, 8, 7]]
    assert_equal( a, q )
  end

  # Deprecated b/c of very strange issues.

  #def test_to_str
  #  assert_equal( "a", :a.to_str )
  #  assert_equal( "abc", :abc.to_str )
  #  assert_equal( '#$%', :'#$%'.to_str )
  #end

end


require 'time'

class TestTimeConversion < Test::Unit::TestCase

  def setup
    @t = Time.parse('4/20/2005 15:37')
  end

  def test_to_date
    assert_instance_of( ::Date, @t.to_date )
  end

  #def test_to_s
  #  assert_equal( "Wed Apr 20 15:37:00 PDT 2005", @t.to_s )
  #end

  def test_to_time
    assert_instance_of( ::Time, @t.to_time )
  end

end

