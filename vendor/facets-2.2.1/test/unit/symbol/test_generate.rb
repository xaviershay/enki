# Test for facets/symbol/generate

require 'facets/symbol/generate.rb'

require 'test/unit'

class TestSymbol < Test::Unit::TestCase

  def test_generate
    assert_equal( Symbol.generate, :'<1>' )
  end

end
