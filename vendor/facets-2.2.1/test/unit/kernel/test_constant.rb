# Test for lib/facets/kernel/constant

require 'facets/kernel/constant.rb'

require 'test/unit'

class TCKernel < Test::Unit::TestCase

  def test_constant
    c = ::Test::Unit::TestCase.name
    assert_equal( ::Test::Unit::TestCase, constant(c) )
    c = "Test::Unit::TestCase"
    assert_equal( ::Test::Unit::TestCase, constant(c) )
    c = "Unit::TestCase"
    assert_equal( ::Test::Unit::TestCase, Test.constant(c) )
    c = "TestCase"
    assert_equal( ::Test::Unit::TestCase, Test::Unit.constant(c) )
  end

end

