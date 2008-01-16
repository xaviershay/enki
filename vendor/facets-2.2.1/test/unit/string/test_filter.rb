# Test for facets/string/filter

require 'facets/string/filter.rb'

require 'test/unit'

class TestStringFilter < Test::Unit::TestCase

  def test_word_filter
    s = "this is a test"
    n = s.word_filter{ |w| "#{w}1" }
    assert_equal( 'this1 is1 a1 test1', n )
  end

  def test_word_filter!
    s = "this is a test"
    s.word_filter!{ |w| "#{w}1" }
    assert_equal( 'this1 is1 a1 test1', s )
  end

end
