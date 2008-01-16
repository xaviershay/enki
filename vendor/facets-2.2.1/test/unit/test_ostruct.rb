# Test facets/ostruct.rb

require 'facets/ostruct.rb'
require 'test/unit'

class TestOpenStruct < Test::Unit::TestCase

  def setup
    @o = OpenStruct.new(:q => 1)
  end

  def test_update
    o = OpenStruct.new( { :a => 1 } )
    h = { :b => 2 }
    assert_nothing_raised { o.__update__( h ) }
    assert_equal( 2, o.b )
  end

  def test_merge_1
    o = OpenStruct.new( { :a => 1 } )
    h = { :b => 2 }
    q = o.__merge__( h )
    assert_equal( 1, q.a )
    assert_equal( 2, q.b )
  end

  def test_merge_2
    o1 = OpenStruct.new( { :a => 1 } )
    o2 = OpenStruct.new( { :b => 2 } )
    q = o1.__merge__( o2 )
    assert_equal( 1, q.a )
    assert_equal( 2, q.b )
  end

  def test_store
    @o.instance_delegate.store(:a,1)
    assert_equal( 1, @o.a )
  end

  def test_update
    @o.instance_delegate.update(:a=>1)
    assert_equal( 1, @o.a )
  end

  def test_op_fetch
    o = OpenStruct.new( { :a => 1 } )
    assert_equal( 1, o[:a] )
  end

  def test_op_store
    o = OpenStruct.new( { :a => 1 } )
    assert_nothing_raised { o[:b] = 2 }
    assert_equal( 2, o.b )
  end

  def test_update
    o = OpenStruct.new( { :a => 1 } )
    h = { :b => 2 }
    assert_nothing_raised { o.__update__( h ) }
    assert_equal( 2, o.b )
  end

  def test_merge_1
    o = OpenStruct.new( { :a => 1 } )
    h = { :b => 2 }
    q = o.__merge__( h )
    assert_equal( 1, q.a )
    assert_equal( 2, q.b )
  end

  def test_merge_2
    o1 = OpenStruct.new( { :a => 1 } )
    o2 = OpenStruct.new( { :b => 2 } )
    q = o1.__merge__( o2 )
    assert_equal( 1, q.a )
    assert_equal( 2, q.b )
  end

end

class TestOpenStructInitialize < Test::Unit::TestCase

  class Person < OpenStruct; end

  def test_1_old_functionality
    o = OpenStruct.new
    assert_nil(o.foo)
    o.foo = :bar
    assert_equal(:bar, o.foo)
    o.delete_field(:foo)
    assert_nil(o.foo)
    o1 = OpenStruct.new(:x => 1, :y => 2)
    assert_equal(1, o1.x)
    assert_equal(2, o1.y)
    o2 = OpenStruct.new(:x => 1, :y => 2)
    assert(o1 == o2)
  end

  def test_2_new_functionality
    person = OpenStruct.new do |p|
      p.name = 'John Smith'
      p.gender  = :M
      p.age     = 71
    end
    assert_equal('John Smith', person.name)
    assert_equal(:M, person.gender)
    assert_equal(71, person.age)
    assert_equal(nil, person.address)
    person = OpenStruct.new(:gender => :M, :age => 71) do |p|
      p.name = 'John Smith'
    end
    assert_equal('John Smith', person.name)
    assert_equal(:M, person.gender)
    assert_equal(71, person.age)
    assert_equal(nil, person.address)
  end

  def test_3_subclass
    person = Person.new do |p|
      p.name = 'John Smith'
      p.gender  = :M
      p.age     = 71
    end
    assert_equal('John Smith', person.name)
    assert_equal(:M, person.gender)
    assert_equal(71, person.age)
    assert_equal(nil, person.address)
    person = Person.new(:gender => :M, :age => 71) do |p|
      p.name = 'John Smith'
    end
    assert_equal('John Smith', person.name)
    assert_equal(:M, person.gender)
    assert_equal(71, person.age)
    assert_equal(nil, person.address)
  end
end

class TestHashToOpenStruct < Test::Unit::TestCase

  def test_to_ostruct
    a = { :a => 1, :b => 2, :c => 3 }
    ao = a.to_ostruct
    assert_equal( a[:a], ao.a )
    assert_equal( a[:b], ao.b )
    assert_equal( a[:c], ao.c )
  end

  def test_to_ostruct_recurse
    a = { :a => 1, :b => 2, :c => { :x => 4 } }
    ao = a.to_ostruct_recurse
    assert_equal(  a[:a], ao.a )
    assert_equal(  a[:b], ao.b )
    assert_equal(  a[:c][:x], ao.c.x )
  end

  def test_to_ostruct_recurse_with_recursion
    a = {}
    a[:a] = a
    ao = a.to_ostruct_recurse
    assert_equal( ao, ao.a )
  end

  def test_to_ostruct_advanced
    h = { 'a' => { 'b' => 1 } }
    o = h.to_ostruct_recurse( { h['a'] => h['a'] } )
    assert_equal( 1, o.a['b'] )
    assert( Hash === o.a )
  end

end

