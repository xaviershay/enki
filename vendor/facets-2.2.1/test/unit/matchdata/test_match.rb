# Test for lib/facets/matchdata/matchset

require 'facets/matchdata/match.rb'

require 'test/unit'

class Test_MatchData_Match < Test::Unit::TestCase

  def test_match
    md = /X(a)(b)(c)X/.match("YXabcXY")
    assert_equal( "XabcX", md.match )
  end

end
