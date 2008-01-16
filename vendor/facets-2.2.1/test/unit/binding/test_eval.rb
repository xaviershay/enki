# Test for facets/binding/eval.rb

require 'facets/binding/eval.rb'
require 'test/unit'

class TC_Binding_Eval < Test::Unit::TestCase

  def setup
    x = "hello"
    @bind = binding; @this_line_no = __LINE__
  end

  def test_eval
    assert_equal( "hello", @bind.eval("x") )
  end

end
