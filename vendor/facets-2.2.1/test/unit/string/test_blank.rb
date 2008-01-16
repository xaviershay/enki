# Test for facets/string/blank.rb

require 'facets/string/blank.rb'

require 'test/unit'

class TestStringBlank < Test::Unit::TestCase

  def test_blank?
    assert( ! "xyz".blank? )
    assert( "     ".blank? )
  end

  def test_whitespace?
    assert( ! "xyz".whitespace? )
    assert( "     ".whitespace? )
  end
end
