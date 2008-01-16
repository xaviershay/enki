# Test facets/openobject.rb

require 'facets/openobject.rb'
require 'test/unit'

class TestOpenObject1 < Test::Unit::TestCase

  def test_1_01
    o = OpenObject.new
    assert( o.respond_to?(:key?) )
  end

  def test_1_02
    assert_instance_of( OpenObject, OpenObject[{}] )
  end

  def test_1_03
    f0 = OpenObject.new
    f0[:a] = 1
    #assert_equal( [1], f0.to_a )
    assert_equal( {:a=>1}, f0.to_h )
  end

  def test_1_04
    f0 = OpenObject[:a=>1]
    f0[:b] = 2
    assert_equal( {:a=>1,:b=>2}, f0.to_h )
  end

  def test_1_05
    f0 = OpenObject[:class=>1]
    assert_equal( 1, f0.class )
  end
end

class TestOpenObject2 < Test::Unit::TestCase

  def test_2_01
    f0 = OpenObject[:f0=>"f0"]
    h0 = { :h0=>"h0" }
    assert_equal( OpenObject[:f0=>"f0", :h0=>"h0"], f0.send(:merge,h0) )
    assert_equal( {:f0=>"f0", :h0=>"h0"}, h0.merge( f0 ) )
  end

  def test_2_02
    f1 = OpenObject[:f1=>"f1"]
    h1 = { :h1=>"h1" }
    f1.send(:update,h1)
    h1.update( f1 )
    assert_equal( OpenObject[:f1=>"f1", :h1=>"h1"], f1 )
    assert_equal( {:f1=>"f1", :h1=>"h1"}, h1 )
  end

  def test_2_03
    o = OpenObject[:a=>1,:b=>{:x=>9}]
    assert_equal( 9, o[:b][:x] )
    assert_equal( 9, o.b[:x] )
  end

  def test_2_04
    o = OpenObject["a"=>1,"b"=>{:x=>9}]
    assert_equal( 1, o["a"] )
    assert_equal( 1, o[:a] )
    assert_equal( {:x=>9}, o["b"] )
    assert_equal( {:x=>9}, o[:b] )
    assert_equal( 9, o["b"][:x] )
    assert_equal( nil, o[:b]["x"] )
  end

end

class TestOpenObject3 < Test::Unit::TestCase
  def test_3_01
    fo = OpenObject.new
    9.times{ |i| fo.send( "n#{i}=", 1 ) }
    9.times{ |i|
      assert_equal( 1, fo.send( "n#{i}" ) )
    }
  end
end

class TestOpenObject4 < Test::Unit::TestCase

  def test_4_01
    ho = {}
    fo = OpenObject.new
    5.times{ |i| ho["n#{i}".to_sym]=1 }
    5.times{ |i| fo.send( "n#{i}=", 1 ) }
    assert_equal(ho, fo.to_h)
  end

end

class TestOpenObject5 < Test::Unit::TestCase

  def test_5_01
    p = lambda { |x|
      x.word = "Hello"
    }
    o = p.to_openobject
    assert_equal( "Hello", o.word )
  end

  def test_5_02
    p = lambda { |x|
      x.word = "Hello"
    }
    o = OpenObject[:a=>1,:b=>2]
    assert_instance_of( Proc, o.to_proc )
  end

end
