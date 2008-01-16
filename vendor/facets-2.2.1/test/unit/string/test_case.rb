# Test for facets/string/case

require 'facets/string/case.rb'

require 'test/unit'

class TestStringCase < Test::Unit::TestCase

  def test_capitalized?
    assert( 'Abc'.capitalized? )
  end

  def test_downcase?
    assert( 'abc'.downcase? )
  end

  def test_lowercase?
    assert( 'abc'.lowercase? )
  end

  def test_upcase?
    assert( 'ABC'.upcase? )
  end

  def test_uppercase?
    assert( 'ABC'.uppercase? )
  end

end
