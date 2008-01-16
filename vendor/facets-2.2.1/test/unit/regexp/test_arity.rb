# Test for lib/facets/regexp/arity

require 'facets/regexp/arity.rb'

require 'test/unit'

class TestRegexpArity < Test::Unit::TestCase

  def test_arity
    r = /(1)(2)(3)/
    assert_equal( 3, r.arity )
    r = /(1)(2)(3)(4)/
    assert_equal( 4, r.arity )
    r = /(1)(2)((a)3)/
    assert_equal( 4, r.arity )
    r = /(?#nothing)(1)(2)(3)(?=3)/
    assert_equal( 3, r.arity )
  end

end
