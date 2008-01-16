# Test for facets/string/index

require 'facets/string/nchar.rb'

require 'test/unit'

class TestStringNChar < Test::Unit::TestCase

  def test_nchar
    assert_equal( "abc", "abcxyz".nchar(3) )
    assert_equal( "xyz", "abcxyz".nchar(-3) )
    assert_equal( "HIxyz", "abcxyz".nchar(3, 'HI') )
    assert_equal( "abcHI", "abcxyz".nchar(-3, 'HI') )
  end

end
