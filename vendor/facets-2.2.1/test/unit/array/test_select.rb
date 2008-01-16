#  _____         _
# |_   _|__  ___| |_
#   | |/ _ \/ __| __|
#   | |  __/\__ \ |
#   |_|\___||___/\__|
#

require 'facets/array/select.rb'

require 'test/unit'

class TestArray < Test::Unit::TestCase

  def test_select!
    a = [1,2,3,4,5,6,7,8,9,10]
    a.select!{ |e| e % 2 == 0 }
    assert_equal( [2,4,6,8,10], a)
  end

end
