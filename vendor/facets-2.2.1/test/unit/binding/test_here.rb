# Test for facets/binding/here.rb

require 'facets/binding/here.rb'
require 'test/unit'

class TC_Binding_Here < Test::Unit::TestCase

  def setup
    x = "hello"
    @bind = binding; @this_line_no = __LINE__
  end

  def test_here
    assert_instance_of( Binding, here )
  end

end
