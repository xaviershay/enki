# Test for facets/hash/new

require 'facets/hash/zipnew.rb'

require 'test/unit'

class TestHashNew < Test::Unit::TestCase

  def test_zipnew
    a = [1,2,3]
    b = [4,5,6]
    assert_equal( {1=>4,2=>5,3=>6}, Hash.zipnew(a,b) )
  end

end
