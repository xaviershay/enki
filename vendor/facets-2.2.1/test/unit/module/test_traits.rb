#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |
#   |_|\___||___/\__|
#

require 'facets/module/traits.rb'

require 'test/unit'

class TestModuleTraits < Test::Unit::TestCase

  module A
    def x; "x"; end
    def z; "zA"; end
  end

  module B
    def y; "y"; end
    def z; "zB"; end
  end

  Q = A + B
  R = A - B
  Z = A * { :x => :y }

  def test_add
    assert(Q)
    Q.extend Q
    assert_equal(  "x", Q.x )
    assert_equal(  "y", Q.y )
    assert_equal( "zB", Q.z )
  end

  def test_minus
    assert(R)
    R.extend R
    assert_equal( "x", R.x )
    assert_raises(NoMethodError){ R.z }
  end

  def test_rename
    assert(Z)
    Z.extend Z
    assert_raise(NoMethodError){ Z.x }
    assert_equal(  "x", Z.y )
    assert_equal( "zA", Z.z )
  end

end
