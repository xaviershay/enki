# Test facets/namespace.rb

require 'facets/namespace.rb'  # to be renamed methodspace.rb (?)
require 'test/unit'

class TestSpaceWithModule < Test::Unit::TestCase

  module M
    def x; "x"; end
  end

  class C
    method_space M
  end

  def test_01
    c = C.new
    assert_equal('x', c.m.x)
  end

  def test_02
    c = C.new
    assert_raises(NoMethodError){ c.x }
  end

end

class TestSpaceWithBlock < Test::Unit::TestCase

  class B
    def x; 1; end
  end

  class C < B
    def x; super; end
    method_space :m do
      def x; "x"; end
    end
  end

  def test_01
    c = C.new
    assert_equal('x', c.m.x)
  end

  def test_02
    c = C.new
    assert_equal(1, c.x)
  end

end

class TestIncludeAs < Test::Unit::TestCase

  module MockModule
    def x; "X"; end
    def y; @y; end
  end

  class MockObject
    include_as :mod => MockModule

    def initialize
      @y = "Y"
    end
  end

  def test_01
    m = MockObject.new
    assert_equal( "X", m.mod.x )
  end

  def test_02
    m = MockObject.new
    assert_equal( "Y", m.mod.y )
  end

end
