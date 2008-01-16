# Test facets/compare_on.rb

require 'facets/compare_on.rb'
require 'test/unit'

class TestModuleCompare < Test::Unit::TestCase

  def test_equate_on
    c = Class.new
    c.class_eval { attr_accessor :a, :b ; equate_on :a,:b }
    c1,c2 = c.new,c.new
    c1.a = 10; c1.b = 20
    c2.a = 10; c2.b = 20
    assert_equal( c1, c2 )
    c1.a = 10; c1.b = 10
    c2.a = 10; c2.b = 20
    assert_not_equal( c1, c2 )
    c1.a = 10; c1.b = 20
    c2.a = 20; c2.b = 20
    assert_not_equal( c1, c2 )
  end

  def test_sort_on
    c = Class.new
    c.class_eval {
      def initialize(a,b)
        @a=a; @b=b
      end
      sort_on :a,:b
    }
    a = [c.new(10,20),c.new(10,30)]
    assert_equal( a, a.sort )
    a = [c.new(10,30),c.new(10,20)]
    assert_equal( a.reverse, a.sort )
    a = [c.new(10,10),c.new(20,10)]
    assert_equal( a, a.sort )
    a = [c.new(20,10),c.new(10,10)]
    assert_equal( a.reverse, a.sort )
    a = [c.new(10,30),c.new(20,10)]
    assert_equal( a, a.sort )
  end

end


