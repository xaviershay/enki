# Test for facets/symbol/succ'

require 'facets/symbol/succ.rb'

require 'test/unit'

class TestSymbol < Test::Unit::TestCase

  def test_succ
    assert_equal( :b, :a.succ )
    assert_equal( :aab, :aaa.succ )
    assert_equal( :"2", :"1".succ )
  end

end
