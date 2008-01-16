# Test for facets/binding/self.rb

require 'facets/binding/self.rb'
require 'test/unit'

class TC_Binding_Self < Test::Unit::TestCase

  def setup
    x = "hello"
    @bind = binding
  end

  def test_self
    assert_equal( self, @bind.self )
  end

end
