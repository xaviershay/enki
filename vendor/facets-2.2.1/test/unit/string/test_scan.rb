# Test for facets/string/scan

require 'facets/string/scan.rb'

require 'test/unit'

class TestStringScan < Test::Unit::TestCase

  def test_mscan
    r = 'abc,def,gh'.mscan(/[,]/)
    assert( r.all?{ |md| MatchData === md } )
    assert_equal( 2, r.to_a.length )
    assert_equal( ',', r[0][0] )
    assert_equal( ',', r[1][0] )
  end

  def test_divide
    s = "<p>This<b>is</b>a test.</p>"
    d = s.divide( /<.*?>/ )
    e = ["<p>This", "<b>is", "</b>a test.", "</p>"]
    assert_equal(e, d)
  end

  def test_shatter
    s = "<p>This<b>is</b>a test.</p>"
    sh = s.shatter( /<.*?>/ )
    e = ["<p>", "This", "<b>", "is", "</b>", "a test.", "</p>"]
    assert_equal(e, sh)
  end

end
