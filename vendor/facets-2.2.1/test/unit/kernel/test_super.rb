# Test facets/kernel/super

require 'facets/kernel/super.rb'

require 'test/unit'

class TestKernelSuper < Test::Unit::TestCase

  class X ; def x ; 1 ; end ; end
  class Y < X ; def x ; 2 ; end ; end
  class Z < Y ; def x ; superior(X) ; end ; end

  def test_superior
    z = Z.new
    assert_equal( 1, z.x )
  end

  class X2 ; def x ; 1 ; end ; end
  class Y2 < X2 ; def x ; 2 ; end ; end
  class Z2 < Y2 ; def x ; 3 ; end ; end

  def test_super_method
    x = X2.new
    z = Z2.new
    s0 = x.method( :x )
    s1 = z.super_method( X2, :x )
    assert_equal( s0.call, s1.call )
  end

  class A
    def x; "A.x"; end
    def y; "A.y"; end
  end
  class B < A
    def x; "B.x" end
    def y; "B.y" end
  end
  class C < B
    def x; "C.x"; end
    def y; as(B).x ; end
  end

  def test_as
    c = C.new
    assert_equal("B.x", c.y)
    assert_equal("C.x", c.x)
  end

  def test_send_as
    assert_equal( String, "A".send_as(Object, :class) )
  end

end
