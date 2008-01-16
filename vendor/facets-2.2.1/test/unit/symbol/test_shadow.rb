# Test for facets/symbol/shadow

require 'facets/symbol/shadow.rb'

require 'test/unit'

class TestSymbol < Test::Unit::TestCase

  def test_shadow
    assert_equal( :__a__, :a.shadow(2) )
    assert_equal( :_a_, :__a__.shadow(-1) )
  end

end
