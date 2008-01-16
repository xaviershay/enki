# Test for facets/time/change

require 'facets/time/change.rb'

require 'test/unit'
require 'time'

class TestTimeChange < Test::Unit::TestCase

  def test_change
    t = Time.parse('4/20/2006 15:37')
    n = Time.now
    n = n.change( :month=>4, :day=>20, :hour=>15, :min=>37, :year=>2006 )
    assert_equal( t, n )
  end

end
