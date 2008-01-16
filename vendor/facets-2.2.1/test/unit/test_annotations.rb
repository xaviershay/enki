# Test for facets/annotations.rb

require 'test/unit'
require 'facets/annotations'

class TestAnnotation1 < Test::Unit::TestCase
  class X
    def x1 ; end
    ann :x1, :a=>1
    ann :x1, :b=>2
  end

  def test_1_01
    assert_equal( X.ann(:x1,:a), X.ann(:x1,:a) )
    assert_equal( X.ann(:x1,:a).object_id, X.ann(:x1,:a).object_id )
  end
  def test_1_02
    X.ann :x1, :a => 2
    assert_equal( 2, X.ann(:x1,:a) )
  end
end

class TestAnnotation2 < Test::Unit::TestCase
  class X
    def x1 ; end
    ann :x1, :a=>1
    ann :x1, :b=>2
  end
  class Y < X ; end

  def test_2_01
    assert_equal( Y.ann(:x1,:a), Y.ann(:x1,:a) )
    assert_equal( Y.ann(:x1,:a).object_id, Y.ann(:x1,:a).object_id )
  end
  def test_2_02
    assert_equal( 1, Y.ann(:x1,:a) )
    assert_equal( 2, Y.ann(:x1,:b) )
  end
  def test_2_03
    Y.ann :x1,:a => 2
    assert_equal( 2, Y.ann(:x1,:a) )
    assert_equal( 2, Y.ann(:x1,:b) )
  end
end

class TestAnnotation3 < Test::Unit::TestCase
  class X
    ann :foo, Integer
  end
  class Y < X
    ann :foo, String
  end

  def test_3_01
    assert_equal( Integer, X.ann(:foo, :class) )
  end
  def test_3_02
    assert_equal( String, Y.ann(:foo, :class) )
  end
end

class TestAnnotation4 < Test::Unit::TestCase
  class X
    ann :foo, :doc => "hello"
    ann :foo, :bar => []
  end
  class Y < X
    ann :foo, :class => String, :doc => "bye"
  end

  def test_4_01
    assert_equal( "hello", X.ann(:foo,:doc) )
  end
  def test_4_02
    assert_equal( X.ann(:foo), { :doc => "hello", :bar => [] } )
  end
  def test_4_03
    X.ann(:foo,:bar) << "1"
    assert_equal( ["1"], X.ann(:foo,:bar) )
  end
  def test_4_04
    assert_equal( "bye", Y.ann(:foo,:doc) )
  end
  def test_4_05
    #assert_equal( nil, Y.ann(:foo,:bar) )
    assert_equal( ["1"], Y.ann(:foo,:bar) )
  end
  def test_4_06
    Y.ann(:foo, :doc => "cap")
    assert_equal( "cap", Y.ann(:foo, :doc)  )
  end
  def test_4_07
    Y.ann!(:foo,:bar) << "2"
    assert_equal( ["1", "2"], Y.ann(:foo,:bar) )
    assert_equal( ["1", "2"], Y.ann(:foo,:bar) )
    assert_equal( ["1"], X.ann(:foo,:bar) )
  end
end

