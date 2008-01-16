#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |
#   |_|\___||___/\__|
#

require 'facets/array/rotate.rb'

require 'test/unit'

class TestArrayRotate < Test::Unit::TestCase

  def test_rotate
    a = [1,2,3]
    assert_equal( [3,1,2], a.rotate, 'clockwise' )
    assert_equal( [2,3,1], a.rotate(-1), 'counter-clockwise' )
  end

  def test_rotate!
    a = [1,2,3]
    a.rotate!
    assert_equal( [3,1,2], a, 'clockwise' )
    a.rotate!(-1)
    assert_equal( [1,2,3], a, 'counter-clockwise' )
  end

end



