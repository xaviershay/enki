# Test facets/string/indexable

require 'facets/string/indexable.rb'

require 'test/unit'

class TestStringIndexable < Test::Unit::TestCase

  def test_first
    assert_equal( "a", "abcxyz".first )
    assert_equal( "ax", "ax by cz".first(' ') )
    assert_equal( "a", "a\nb\nc".first("\n") )
  end

  def test_first_eq
    s = "abc"
    s.first = "123"
    assert_equal( "123abc", s )
    s = "a\nbc"
    s.first = "123"
    assert_equal( "123a\nbc", s )
  end

  def test_first!
    s = "a\nbc"
    s.first!("\n")
    assert_equal( "bc", s )
  end

  def test_last
    assert_equal( "z", "abcxyz".last )
    assert_equal( "cz", "ax by cz".last(' ') )
    assert_equal( "c", "a\nb\nc".last("\n") )
  end

  def test_last_eq
    s = "abc"
    s.last = "123"
    assert_equal( "abc123", s )
    s = "a\nbc"
    s.last = "123"
    assert_equal( "a\nbc123", s )
  end

  def test_last!
    s = "abc"
    s.last!
    assert_equal( "ab", s )
    s = "a b c"
    s.last!(' ')
    assert_equal( "a b", s )
  end

  def test_index_all
    assert_equal( [0,4,8], "a123a567a9".index_all(/a/) )
  end

  def test_index_all_with_string
    assert_equal( [0,4,8], "a123a567a9".index_all('a') )
  end

  def test_index_all_with_regexp_reuse
    assert_equal( [0,4,8], "a123a567a9".index_all(/a/, true) )
    assert_equal( [0], "bbb".index_all('bb', false) )
    assert_equal( [0,1], "bbb".index_all('bb', true) )
  end

end
