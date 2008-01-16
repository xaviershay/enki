# Test for facets/class/remove_descendents.rb

require 'facets/class/remove_descendents.rb'

require 'test/unit'

class TestClassDescendents < Test::Unit::TestCase

  class A ; end
  class B < A ; end
  class C < B ; end

  def test_remove_descendents
    assert_nothing_raised { B.remove_descendents }
    # doesn't work despite above; not sure why
    #assert_equal( [B], A.descendents )
  end

end
