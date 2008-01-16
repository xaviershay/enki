# Test for facets/autoarray.rb

require 'facets/autoarray.rb'
require 'test/unit'

class TC_Autoarray

  def test_001
    a = Autoarray.new
    assert_equal( 12, a[1][2][3] = 12 )
    assert_equal( [nil, [nil, nil, [nil, nil, nil, 12]]], a )
    assert_equal( [], a[2][3][4] )
    assert_equal( [nil, [nil, nil, [nil, nil, nil, 12]]], a )
    assert_equal( "Negative", a[1][-2][1] = "Negative" )
    assert_equal( [nil, [nil, [nil, "Negative"], [nil, nil, nil, 12]]], a )
  end

end
