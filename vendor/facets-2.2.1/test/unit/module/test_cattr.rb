# Test for facets/module/cattr

require 'facets/module/cattr.rb'

require 'test/unit'

class TCModule < Test::Unit::TestCase

  class MockObject
    def initialize
      @@a = 10
    end
    def b ; @@b ; end
  end

  def test_cattr
    assert_nothing_raised {
      MockObject.class_eval { cattr :a }
    }
    t = MockObject.new
    assert_equal( 10, t.a )
  end

  def test_cattr_reader
    assert_nothing_raised {
      MockObject.class_eval { cattr_reader :a }
    }
    t = MockObject.new
    assert_equal( 10, t.a )
  end

  def test_cattr_writer
    assert_nothing_raised {
      MockObject.class_eval { cattr_writer :b }
    }
    t = MockObject.new
    t.b = 5
    assert_equal( 5, t.b )
  end

  def test_cattr_accessor
    assert_nothing_raised {
      MockObject.class_eval { cattr_accessor :c }
    }
    t = MockObject.new
    t.c = 50
    assert_equal( 50, t.c )
  end

end
