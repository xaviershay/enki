# Test for lib/facets/kernel/deepcopy

require 'facets/kernel/deepcopy.rb'

require 'test/unit'

class TestKernelCopy < Test::Unit::TestCase

  # fixtures for copy / deep_copy
  class A
    attr_reader :a
    def initialize
      @a = 1
    end
  end

  class B
    attr_reader :b
    def initialize
      @b = A.new
    end
  end

  def test_deep_copy
    o = B.new
    oc = o.deep_copy
    assert_equal( 1, o.b.a  )
  end

end
