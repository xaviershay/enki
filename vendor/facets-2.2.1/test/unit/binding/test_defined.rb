# Test for facets/binding/defined.rb

require 'facets/binding/defined.rb'
require 'test/unit'

class TC_Binding_Defined < Test::Unit::TestCase

  def setup
    x = "hello"
    @bind = binding; @this_line_no = __LINE__
  end

  def test_defined?
    assert( @bind.defined?("x") )
  end

end
