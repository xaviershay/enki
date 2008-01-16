# Test for facets/symbol/not

require 'facets/symbol/not.rb'

require 'test/unit'

class TCSymbol < Test::Unit::TestCase

  def test_not
    assert_equal( :"~a", ~:a )
    a = :a
    n = ~a
    assert( n.not? )
  end

end
