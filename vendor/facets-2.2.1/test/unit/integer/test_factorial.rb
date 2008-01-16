# Test for facets/integer/factorial

require 'facets/integer/factorial.rb'

require 'test/unit'

class TCInteger < Test::Unit::TestCase

  def test_factorial
    assert_equal(  1, 0.factorial )
    assert_equal(  1, 1.factorial )
    assert_equal(  2, 2.factorial )
    assert_equal(  6, 3.factorial )
    assert_equal( 24, 4.factorial )
  end

end
