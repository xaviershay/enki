# Test for facets/string/regesc

require 'facets/string/regesc.rb'

require 'test/unit'

class TestStringRegesc < Test::Unit::TestCase

  def test_regesc
    a = "?"
    b = /#{a.regesc}/
    assert( b =~ "?" )
  end

  def test_resc
    assert_equal( Regexp.escape("'jfiw0[]4"), resc("'jfiw0[]4") )
    assert_equal( Regexp.escape("/////"), resc("/////") )
  end

end

