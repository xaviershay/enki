# Test for facets/string/partitions

require 'facets/string/partitions.rb'

require 'test/unit'

class TestStringPartitions < Test::Unit::TestCase

  def test_bytes
    s = "abc"
    assert_equal( s.unpack('C*'), s.bytes )
  end

  def test_chars
    assert_equal( ["a","b","c"], "abc".chars )
    assert_equal( ["a","b","\n","c"], "ab\nc".chars )
  end

  def test_lines
    assert_equal( ['a','b','c'], "a\nb\nc".lines )
  end

  def test_words_01
    x = "a b c\nd e"
    assert_equal( ['a','b','c','d','e'], x.words )
  end

  def test_words_02
    x = "ab cd\nef"
    assert_equal( ['ab','cd','ef'], x.words )
  end

  def test_words_03
    x = "ab cd \n ef-gh"
    assert_equal( ['ab','cd','ef-gh'], x.words )
  end

  def test_each_char
    a = []
    i = "this"
    i.each_char{ |w| a << w }
    assert_equal( ['t', 'h', 'i', 's'], a )
  end

  def test_each_word
    a = []
    i = "this is a test"
    i.each_word{ |w| a << w }
    assert_equal( ['this', 'is', 'a', 'test'], a )
  end

end
