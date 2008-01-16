# Test for facets/string/op.rb

require 'facets/string/op.rb'
require 'test/unit'

class TC_StringOperators < Test::Unit::TestCase

  def test_minus
    assert_equal("fbar", "foobar" - "oo")
    assert_equal("pia pia!", "pizza pizza!" - "zz")
    assert_equal("", "letters" - /[a-z]+/)
  end

end
