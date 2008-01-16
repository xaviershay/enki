# Test facets/classmethods.rb

require 'facets/classmethods.rb'
require 'test/unit'

class TC_ClassMethods < Test::Unit::TestCase

  # fixture

  module N
    class_methods do
      def n ; 43 ; end
      def s ; self ; end
    end
  end

  class X
    include N
    def n ; 11 ; end
  end

  module K
    include N
    class_methods do
      def n ; super + 1 ; end
    end
  end

  class Z
    include K
  end

  # tests

  def test_01
    assert_equal( 43, N.n )
    assert_equal(  N,  N.s )
  end
  def test_02
    assert_equal( 43, X.n )
    assert_equal(  X, X.s )
  end
  def test_03
    assert_equal( 11, X.new.n )
  end
  def test_04
    assert_equal( 44, K.n )
    assert_equal(  K, K.s )
  end
  def test_05
    assert_equal( 44, Z.n )
    assert_equal(  Z, Z.s )
  end

end
