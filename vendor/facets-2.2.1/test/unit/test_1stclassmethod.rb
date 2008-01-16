require 'test/unit'
require 'facets/1stclassmethod'


class Test1stClassMethod < Test::Unit::TestCase

  class TestWith
    def foo ; end
  end

  def test_method!
    t = TestWith.new
    assert_equal( t.method!(:foo).__id__, t.method!(:foo).__id__ )
    assert_not_equal( t.method(:foo).__id__, t.method(:foo).__id__ )
  end

  def test_this
    assert_equal( this, method(:test_this) )
  end

end
