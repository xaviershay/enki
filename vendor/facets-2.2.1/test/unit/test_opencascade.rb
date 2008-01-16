# Test facets/opencascade.rb

require 'facets/opencascade.rb'
require 'test/unit'

class TestOpenCascade1 < Test::Unit::TestCase

  def test_1_01
    o = OpenCascade[:a=>1,:b=>2]
    assert_equal( 1, o.a )
    assert_equal( 2, o.b )
  end

  def test_1_02
    o = OpenCascade[:a=>1,:b=>2,:c=>{:x=>9}]
    assert_equal( 9, o.c.x )
  end

  def test_1_03
    f0 = OpenCascade.new
    f0[:a] = 1
    assert_equal( [[:a,1]], f0.to_a )
    assert_equal( {:a=>1}, f0.to_h )
  end

  def test_1_04
    f0 = OpenCascade[:a=>1]
    f0[:b] = 2
    assert_equal( {:a=>1,:b=>2}, f0.to_h )
  end
end

class TestOpenCascade2 < Test::Unit::TestCase

  def test_02_001
    f0 = OpenCascade[:f0=>"f0"]
    h0 = { :h0=>"h0" }
    assert_equal( OpenCascade[:f0=>"f0", :h0=>"h0"], f0.send(:merge,h0) )
    assert_equal( {:f0=>"f0", :h0=>"h0"}, h0.merge( f0 ) )
  end

  def test_02_002
    f1 = OpenCascade[:f1=>"f1"]
    h1 = { :h1=>"h1" }
    f1.send(:update, h1)
    h1.update( f1 )
    assert_equal( OpenCascade[:f1=>"f1", :h1=>"h1"], f1 )
    assert_equal( {:f1=>"f1", :h1=>"h1"}, h1 )
  end
end

class TestOpenCascade3 < Test::Unit::TestCase

  def test_01_001
    fo = OpenCascade.new
    99.times{ |i| fo.__send__( "n#{i}=", 1 ) }
    99.times{ |i|
      assert_equal( 1, fo.__send__( "n#{i}" ) )
    }
  end
end
