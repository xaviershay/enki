# Test facets/cut.rb

require 'facets/cut.rb'
require 'test/unit'

class TestCut < Test::Unit::TestCase

  class X
    def x; "x"; end
  end

  Xc = Cut.new(X) do
    def x; '{' + super + '}'; end
  end

  def test_method_is_wrapped_by_advice
      o = X.new
      assert_equal("{x}", o.x)
  end

end
