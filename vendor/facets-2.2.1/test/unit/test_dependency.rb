# Test lib/facets/dependency.rb

require 'facets/dependency.rb'

require 'test/unit'

class DependableTest1 < Test::Unit::TestCase

  class C
    #extend MethodDependency

    attr :s
    def initialize
      @s = ''
    end

    def x ; @s << 'x'; end
    def y ; @s << 'y'; end
    def z ; @s << 'z'; end

    depend :x => :y
    depend :z => [:x, :y]
  end

  module M
    #extend MethodDependency

    attr :s
    def initialize
      @s = ''
    end

    def x ; @s << 'x'; end
    def y ; @s << 'y'; end
    def z ; @s << 'z'; end

    depend :x => :y
    depend :z => [:x, :y]
  end

  class D
    include M
  end

  def test_01
    c = C.new
    c.x
    assert_equal( 'yx', c.s )
  end

  def test_02
    c = C.new
    c.z
    assert_equal( 'yxz', c.s )
  end

  def test_03
    c = D.new
    c.x
    assert_equal( 'yx', c.s )
  end

  def test_04
    c = D.new
    c.z
    assert_equal( 'yxz', c.s )
  end

end
