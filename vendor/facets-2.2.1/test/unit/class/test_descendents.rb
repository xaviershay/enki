# Test for facets/class/descendents.rb

require 'facets/class/descendents.rb'

require 'test/unit'

class TestClassDescendents < Test::Unit::TestCase

  class A ; end
  class B < A ; end
  class C < B ; end

  def test_descendents
    assert_equal( [C,B], A.descendents )
  end

end
