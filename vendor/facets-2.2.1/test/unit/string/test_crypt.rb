# Test for facets/string/crypt

require 'facets/string/crypt.rb'

require 'test/unit'

class TestStringCrypt < Test::Unit::TestCase

  def test_crypt
    assert_nothing_raised { "abc 123".crypt }
  end

  def test_crypt!
    assert_nothing_raised { "abc 123".crypt! }
  end

end
