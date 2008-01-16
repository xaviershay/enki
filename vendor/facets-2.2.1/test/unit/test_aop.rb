require 'test/unit'
require 'facets/aop'

class TestAop < Test::Unit::TestCase

  class X
    def x; "x"; end
    def y; "y"; end
    def q; "<" + x + ">"; end
  end

  Xa = Aspect.new do
    join :x do |jp|
      jp == :x
    end

    def x(target); '{' + target.super + '}'; end
  end

  X.apply(Xa)

  def setup
    @x1 = X.new
  end

  def test_class
    assert_equal(X, @x1.class)
  end

  def test_public_methods
    meths = @x1.public_methods(false)
    assert(meths.include?("y"))
    assert(meths.include?("q"))
    assert(meths.include?("x"))
  end

  def test_x
    assert_equal("{x}", @x1.x)
  end

  def test_y
    assert_equal("y", @x1.y)
  end

  def test_q
    assert_equal("<{x}>", @x1.q)
  end

end
